FROM innovanon/bare as book
USER root
ARG EXT=tgz
ARG LFS=/mnt/lfs
ARG TEST=
#COPY          ./stage-5.$EXT    /tmp/
COPY          ./stage-5         /tmp/stage-5
RUN sleep 91                                             \
 && ( cd                        /tmp/stage-5             \
 &&   tar  pcf - .                                       ) \
  | tar  pxf - -C /                                        \
 && rm -rf                      /tmp/stage-5             \
 && chmod -v 1777               /tmp                     \
 && apt update                                           \
 && [ -x           /tmp/dpkg.list ]                      \
 && apt install  $(/tmp/dpkg.list)                       \
 && exec true || exec false
 #&& chown -R lfs:lfs /var/lib/tor

WORKDIR $LFS/sources
USER lfs
# TODO tor+svn
RUN test -x  /tmp/svn.url                                 \
 &&        svn co $(/tmp/svn.url)                      \
 && cd BOOK                                               \
 && /tmp/dump-commands.awk Makefile | tee Makefile.new    \
 && tsocks make -f Makefile.new REV=systemd               \
      dump-commands md5sums wget-list                     \
 && echo       http://isl.gforge.inria.fr/isl-0.23.tar.xz \
 >> $HOME/lfs-systemd/wget-list                           \
 && echo cc8155dfe8550e59299a2368dbaa7d04 isl-0.23.tar.xz \
 >> $HOME/lfs-systemd/md5sums                             \
 && exec true || exec false
                                    
USER root
RUN apt-mark auto $(/tmp/dpkg.list)                      \
 && rm    -v        /tmp/dpkg.list                       \
                    /tmp/svn.url                         \
 && clean.sh                                       \
 && exec true || exec false

#FROM book as squash-tmp
#USER root
#RUN  squash.sh
#FROM scratch as squash
#ADD --from=squash-tmp /tmp/final.tar /

FROM book
