# The `mysql` Type #

This module provides a basic type for managing the installation and setup of MySQL.

## Example ##

``` puppet
mysql::user { "myapp": password => passwordgen('myapp') }
mysql::database { "myapp-dev": user => 'myapp' }
```

## Caveats ##

This type is currently *incredibly* primitive.
