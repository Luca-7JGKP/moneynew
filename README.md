# Money Management Plugin for WoltLab Suite

A comprehensive WoltLab Suite 6.1 plugin demonstrating best practices for plugin development, including proper FontAwesome integration, redirect handling, template structure, and database error handling.

## Features

- Transaction management (add, view, delete)
- Proper FontAwesome icon integration
- Correct redirect handling after form submissions
- Template files with proper header/footer includes
- Comprehensive database error handling with logging

## WoltLab 6.1 Best Practices Implemented

### 1. FontAwesome Integration
All templates use the proper `<fa-icon>` web component syntax for FontAwesome icons:
```smarty
<fa-icon name="wallet"></fa-icon>
<fa-icon name="plus"></fa-icon>
```

Icons are automatically loaded through WoltLab's built-in FontAwesome integration, no additional CSS/JS linking required.

### 2. Proper Redirect Handling
All action classes use `HeaderUtil::redirect()` for redirects after form submissions:
```php
HeaderUtil::redirect(
    LinkHandler::getInstance()->getLink('TransactionList')
);
exit;
```

This ensures users are properly navigated back to the overview pages after actions.

### 3. Template Header/Footer Integration
All templates include proper header and footer:
```smarty
{include file='header' pageTitle='wcf.money.transaction.list'}
<!-- Template content -->
{include file='footer'}
```

This ensures proper page structure and prevents display issues.

### 4. Database Error Handling
All database operations include comprehensive error handling:
- Try-catch blocks wrap database operations
- Errors are logged using `\wcf\functions\exception\logThrowable()`
- Failures don't disrupt execution
- User-friendly error messages are displayed

Example from TransactionAction.class.php:
```php
try {
    $transaction = parent::create();
    return $transaction;
} catch (\Exception $e) {
    \wcf\functions\exception\logThrowable($e);
    throw new SystemException('Failed to create transaction: ' . $e->getMessage(), 0, '', $e);
}
```

## File Structure

```
moneynew/
├── package.xml                                          # Plugin descriptor
├── install.sql                                          # Database schema
├── language/
│   └── en.xml                                          # English language file
├── files/
│   └── lib/
│       ├── action/
│       │   ├── TransactionAddAction.class.php          # Add transaction action with proper redirect
│       │   └── TransactionDeleteAction.class.php       # Delete transaction action with proper redirect
│       ├── data/
│       │   └── transaction/
│       │       ├── Transaction.class.php               # Transaction database object
│       │       └── TransactionAction.class.php         # Transaction CRUD with error handling
│       └── page/
│           └── TransactionListPage.class.php           # List page with error handling
└── templates/
    ├── transactionList.tpl                             # List view with FontAwesome icons
    └── transactionAdd.tpl                              # Add form with FontAwesome icons
```

## Installation

1. Create a package file (.tar) containing all files
2. Install through WoltLab Suite Admin Control Panel
3. The plugin will create necessary database tables automatically

## Requirements

- WoltLab Suite Core 6.1.0 or higher

## Key Improvements Over Common Issues

1. **Icons Not Displaying**: Uses proper `<fa-icon>` web components instead of old `<span class="icon">` syntax
2. **Redirect Issues**: Uses `HeaderUtil::redirect()` with proper LinkHandler integration
3. **Template Display Issues**: All templates include proper `{include file='header'}` and `{include file='footer'}`
4. **SQL Query Issues**: Comprehensive try-catch blocks with logging and graceful error handling
5. **Form Security**: All forms include `{csrfToken}` for CSRF protection

## Reference

All implementations follow the official WoltLab Suite 6.1 documentation:
https://docs.woltlab.com/6.1/