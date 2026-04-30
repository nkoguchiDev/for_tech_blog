$TTL 86400
@       IN      SOA     example.com. root.example.com. (
        2023031501      ;Serial
        3600            ;Refresh
        1800            ;Retry
        604800          ;Expire
        865400          ;Minimum TTL
)
@       IN      NS      example.com.
@       IN      A       172.20.1.1
www     IN      A       172.20.1.2
api     IN      A       172.20.1.3
stg     IN      A       172.20.10.1
dev     IN      A       172.20.100.1