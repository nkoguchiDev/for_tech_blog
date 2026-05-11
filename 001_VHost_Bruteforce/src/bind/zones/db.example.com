$TTL 86400
@       IN      SOA     example.com. root.example.com. (
        2023031501      ;Serial
        3600            ;Refresh
        1800            ;Retry
        604800          ;Expire
        865400          ;Minimum TTL
)
@       IN      NS      example.com.
@       IN      A       172.30.1.1
www     IN      A       172.30.1.100
api     IN      A       172.30.1.100
stg     IN      A       172.30.1.100
dev     IN      A       172.30.1.100