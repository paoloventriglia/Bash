# Run yum update and install make and gcc
# yum update -y && yum install -y make gcc

# Unpack source code files
tar xvzf redis-3.2.8.tar.gz

# Change directory to redis
cd redis-3.2.8

# Compile the src code file, this will require make and gcc (if you need to install them uncomment the second line)
make

# Make install will copy the executable to the relevant locations
make install

# Make redis folder for config file
mkdir /etc/redis

# Create working directory
mkdir /var/redis/redisd

# Copy init script file from utils to init.d 
cp utils/redisd /etc/init.d/redisd

# Copy redis config file /etc/redis
cp redis.conf /etc/redis/redis.conf

# Add redis service to chkconfig
chkconfig --add redisd

# Enable redis service to start at startup
chkconfig redisd on

# Make redis service script executable
chmod +x  /etc/init.d/redisd
