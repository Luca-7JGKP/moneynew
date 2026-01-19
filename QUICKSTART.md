# Quick Start Guide - WoltLab Money Management Plugin

## Overview
This plugin demonstrates proper implementation of WoltLab Suite 6.1 best practices, specifically addressing:
- FontAwesome icon integration
- Redirect handling after form submissions
- Template header/footer includes
- Database error handling with logging

## Files Overview

### Core Files
- **package.xml** - Plugin package descriptor with metadata and installation instructions
- **install.sql** - Database schema for the transaction table
- **language/en.xml** - English language strings for internationalization

### PHP Classes
- **files/lib/data/transaction/Transaction.class.php** - Database object representing a transaction
- **files/lib/data/transaction/TransactionAction.class.php** - CRUD operations with comprehensive error handling
- **files/lib/action/TransactionAddAction.class.php** - Form submission handler with proper redirect
- **files/lib/action/TransactionDeleteAction.class.php** - Delete action handler with proper redirect
- **files/lib/page/TransactionListPage.class.php** - List page with database error handling

### Templates
- **templates/transactionList.tpl** - Transaction list view with FontAwesome icons
- **templates/transactionAdd.tpl** - Add transaction form with FontAwesome icons

## Key Features Demonstrated

### 1. FontAwesome Icons (Issue #1)
✅ All icons use the modern `<fa-icon>` web component
```smarty
<fa-icon name="wallet"></fa-icon>
<fa-icon name="plus"></fa-icon>
<fa-icon name="trash"></fa-icon>
```

### 2. Proper Redirects (Issue #2)
✅ All form actions use `HeaderUtil::redirect()` with proper LinkHandler
```php
HeaderUtil::redirect(
    LinkHandler::getInstance()->getLink('TransactionList')
);
exit;
```

### 3. Template Structure (Issue #3)
✅ All templates include proper header and footer
```smarty
{include file='header' pageTitle='wcf.money.transaction.list'}
<!-- content -->
{include file='footer'}
```

### 4. Error Handling (Issue #4)
✅ All database operations wrapped in try-catch with logging
```php
try {
    $transaction = parent::create();
    return $transaction;
} catch (\Exception $e) {
    \wcf\functions\exception\logThrowable($e);
    throw new SystemException('Failed to create transaction: ' . $e->getMessage(), 0, '', $e);
}
```

## How to Use This Plugin

### Installation (Hypothetical - for WoltLab Suite installation)
1. Package all files into a .tar archive
2. Upload through WoltLab Suite Admin Control Panel
3. Install the plugin
4. Database tables will be created automatically

### For Development Reference
This plugin serves as a reference implementation. Developers can:
1. Review the code structure
2. Copy patterns for their own plugins
3. Use the verification script to check their implementations
4. Reference the detailed documentation in FIXES_DOCUMENTATION.md

## Testing the Implementation

Run the verification script:
```bash
./verify_plugin.sh
```

This will check:
- ✓ FontAwesome integration
- ✓ Redirect implementation
- ✓ Template structure
- ✓ Error handling
- ✓ Additional best practices

## Code Examples

### Adding a New Action with Redirect
```php
<?php
namespace wcf\action;

use wcf\util\HeaderUtil;
use wcf\system\request\LinkHandler;

class MyAction extends AbstractAction
{
    public function execute()
    {
        parent::execute();
        
        // Do your action logic here
        
        $this->executed();
        
        // Proper redirect
        HeaderUtil::redirect(
            LinkHandler::getInstance()->getLink('MyPage')
        );
        exit;
    }
}
```

### Adding Database Operations with Error Handling
```php
<?php
try {
    $sql = "SELECT * FROM wcf" . WCF_N . "_mytable WHERE id = ?";
    $statement = WCF::getDB()->prepareStatement($sql);
    $statement->execute([$id]);
    $data = $statement->fetchArray();
} catch (\Exception $e) {
    \wcf\functions\exception\logThrowable($e);
    // Handle error gracefully
    $data = null;
}
```

### Using FontAwesome Icons in Templates
```smarty
{* Header icon *}
<fa-icon size="32" name="wallet"></fa-icon>

{* Button with icon *}
<a href="{link}..." class="button">
    <fa-icon name="plus"></fa-icon>
    <span>{lang}wcf.button.add{/lang}</span>
</a>

{* Inline icon *}
<fa-icon name="info-circle"></fa-icon>
```

## Reference Documentation

- **README.md** - Overview and features
- **FIXES_DOCUMENTATION.md** - Detailed explanation of all fixes with code references
- **verify_plugin.sh** - Automated verification script
- WoltLab Docs: https://docs.woltlab.com/6.1/

## Security Features

1. **CSRF Protection** - All forms include `{csrfToken}`
2. **SQL Injection Prevention** - Uses prepared statements and PreparedStatementConditionBuilder
3. **Input Sanitization** - Uses StringUtil::trim() and type validation
4. **Error Logging** - All exceptions logged without exposing sensitive data to users
5. **Permission Checks** - Action classes define permission requirements

## Browser Compatibility

FontAwesome icons use web components which are supported in:
- Chrome 54+
- Firefox 63+
- Safari 10.1+
- Edge 79+

WoltLab Suite 6.1 automatically includes necessary polyfills for older browsers.

## Support and Issues

For WoltLab Suite-specific questions, refer to:
- Official Documentation: https://docs.woltlab.com/6.1/
- Community Forum: https://www.woltlab.com/community/

## License

This is a reference implementation for educational purposes, demonstrating WoltLab Suite 6.1 best practices.
