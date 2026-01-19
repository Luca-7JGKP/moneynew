#!/bin/bash

# WoltLab Plugin Verification Script
# This script verifies that all best practices have been implemented

echo "=========================================="
echo "WoltLab Plugin Best Practices Verification"
echo "=========================================="
echo ""

ERRORS=0
WARNINGS=0
SUCCESSES=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((SUCCESSES++))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((ERRORS++))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

echo "1. Checking FontAwesome Integration..."
echo "========================================"

# Check for proper fa-icon usage in templates
if grep -r "<fa-icon" templates/ > /dev/null 2>&1; then
    check_pass "Templates use <fa-icon> web components"
    ICON_COUNT=$(grep -r "<fa-icon" templates/ | wc -l)
    echo "   Found $ICON_COUNT icon usages"
else
    check_fail "No <fa-icon> web components found in templates"
fi

# Check for old Font Awesome syntax (potential issue)
if grep -r 'class="icon ' templates/ > /dev/null 2>&1; then
    check_warn "Old icon syntax found - should be migrated to <fa-icon>"
else
    check_pass "No old icon syntax found"
fi

echo ""
echo "2. Checking Redirect Implementation..."
echo "========================================"

# Check for HeaderUtil::redirect usage
if grep -r "HeaderUtil::redirect" files/ > /dev/null 2>&1; then
    check_pass "HeaderUtil::redirect() is used"
    REDIRECT_COUNT=$(grep -r "HeaderUtil::redirect" files/ | wc -l)
    echo "   Found $REDIRECT_COUNT redirect usages"
else
    check_fail "No HeaderUtil::redirect() usage found"
fi

# Check for proper exit after redirect
if grep -A1 "HeaderUtil::redirect" files/ | grep -q "exit;"; then
    check_pass "Redirects are followed by exit;"
else
    check_warn "Some redirects may not have exit; statement"
fi

# Check for LinkHandler usage with redirects
if grep -B2 "HeaderUtil::redirect" files/ | grep -q "LinkHandler::getInstance()->getLink"; then
    check_pass "LinkHandler is used with redirects"
else
    check_warn "Consider using LinkHandler for generating redirect URLs"
fi

echo ""
echo "3. Checking Template Header/Footer..."
echo "========================================"

# Check all .tpl files for header include
TPL_COUNT=$(find templates/ -name "*.tpl" 2>/dev/null | wc -l)
if [ $TPL_COUNT -eq 0 ]; then
    check_warn "No template files found"
else
    echo "   Found $TPL_COUNT template files"
    
    HEADER_COUNT=$(grep -l "{include file='header'" templates/*.tpl 2>/dev/null | wc -l)
    FOOTER_COUNT=$(grep -l "{include file='footer'}" templates/*.tpl 2>/dev/null | wc -l)
    
    if [ $HEADER_COUNT -eq $TPL_COUNT ]; then
        check_pass "All templates include header"
    else
        check_fail "Some templates missing header include ($HEADER_COUNT/$TPL_COUNT)"
    fi
    
    if [ $FOOTER_COUNT -eq $TPL_COUNT ]; then
        check_pass "All templates include footer"
    else
        check_fail "Some templates missing footer include ($FOOTER_COUNT/$TPL_COUNT)"
    fi
fi

echo ""
echo "4. Checking Database Error Handling..."
echo "========================================"

# Check for try-catch blocks in database operations
if grep -r "try {" files/ > /dev/null 2>&1; then
    check_pass "Try-catch blocks found"
    TRY_COUNT=$(grep -r "try {" files/ | wc -l)
    CATCH_COUNT=$(grep -r "catch" files/ | wc -l)
    echo "   Found $TRY_COUNT try blocks and $CATCH_COUNT catch blocks"
else
    check_fail "No try-catch blocks found"
fi

# Check for error logging
if grep -r "logThrowable" files/ > /dev/null 2>&1; then
    check_pass "Error logging implemented"
    LOG_COUNT=$(grep -r "logThrowable" files/ | wc -l)
    echo "   Found $LOG_COUNT logging statements"
else
    check_fail "No error logging found"
fi

# Check for PreparedStatementConditionBuilder usage (SQL injection prevention)
if grep -r "PreparedStatementConditionBuilder" files/ > /dev/null 2>&1; then
    check_pass "PreparedStatementConditionBuilder used (SQL injection safe)"
else
    check_warn "No PreparedStatementConditionBuilder found"
fi

echo ""
echo "5. Checking Additional Best Practices..."
echo "========================================"

# Check for CSRF protection
if grep -r "{csrfToken}" templates/ > /dev/null 2>&1; then
    check_pass "CSRF tokens found in templates"
else
    check_warn "No CSRF tokens found in forms"
fi

# Check for package.xml
if [ -f "package.xml" ]; then
    check_pass "package.xml exists"
    
    # Check for required version
    if grep -q "requiredpackage.*minversion" package.xml; then
        check_pass "Required packages specified in package.xml"
    else
        check_warn "No required packages specified"
    fi
else
    check_fail "package.xml not found"
fi

# Check for install.sql
if [ -f "install.sql" ]; then
    check_pass "install.sql exists"
else
    check_warn "install.sql not found"
fi

# Check for language files
if [ -d "language" ] && find language -name "*.xml" -type f | grep -q .; then
    check_pass "Language files exist"
    LANG_COUNT=$(find language -name "*.xml" -type f | wc -l)
    echo "   Found $LANG_COUNT language file(s)"
else
    check_warn "No language files found"
fi

# Check for input sanitization
if grep -r "StringUtil::" files/ > /dev/null 2>&1; then
    check_pass "Input sanitization found (StringUtil)"
else
    check_warn "Consider adding input sanitization"
fi

# Check for proper class structure
if grep -r "extends AbstractDatabaseObjectAction" files/ > /dev/null 2>&1; then
    check_pass "Proper action class structure (extends AbstractDatabaseObjectAction)"
fi

if grep -r "extends DatabaseObject" files/ > /dev/null 2>&1; then
    check_pass "Proper database object structure (extends DatabaseObject)"
fi

if grep -r "extends AbstractPage" files/ > /dev/null 2>&1; then
    check_pass "Proper page class structure (extends AbstractPage)"
fi

echo ""
echo "=========================================="
echo "Verification Summary"
echo "=========================================="
echo -e "${GREEN}Passed: $SUCCESSES${NC}"
echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
echo -e "${RED}Failed: $ERRORS${NC}"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}All checks passed! Plugin follows WoltLab 6.1 best practices.${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}All critical checks passed, but there are some warnings.${NC}"
    exit 0
else
    echo -e "${RED}Some critical checks failed. Please review the errors above.${NC}"
    exit 1
fi
