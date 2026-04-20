$TTL 86400
@       IN      SOA     example.com. root.example.com. (
        2023031501      ;Serial
        3600            ;Refresh
        1800            ;Retry
        604800          ;Expire
        865400          ;Minimum TTL
)
@       IN      NS      example.com.
@       IN      A       192.168.50.100
www     IN      A       192.168.50.101