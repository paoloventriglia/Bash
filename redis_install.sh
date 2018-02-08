tar xvzf redis-3.2.8.tar.gz
cd redis-3.2.8
make
make install
mkdir /etc/redis
mkdir /var/redis
cp redisd /etc/init.d/redisd
cp redis.conf /etc/redis/redis.conf
mkdir /var/redis/redisd
chkconfig --add redisd
chkconfig redisd on
