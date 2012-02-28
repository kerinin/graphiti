listen 8888 # by default Unicorn listens on port 8080
worker_processes 2 # this should be >= nr_cpus
pid "/home/ubuntu/graphiti/tmp/unicorn.pid"
stderr_path "/home/ubuntu/graphiti/logs/unicorn.log"
stdout_path "/home/ubuntu/graphiti/logs/unicorn.log"
