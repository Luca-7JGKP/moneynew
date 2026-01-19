<?php

namespace wcf\page;

use wcf\data\transaction\Transaction;
use wcf\system\database\util\PreparedStatementConditionBuilder;
use wcf\system\exception\SystemException;
use wcf\system\WCF;

/**
 * Shows a list of transactions.
 */
class TransactionListPage extends AbstractPage
{
    /**
     * @var Transaction[]
     */
    public $transactions = [];

    /**
     * @var string
     */
    public $successMessage = '';

    /**
     * @var string
     */
    public $errorMessage = '';

    /**
     * @inheritDoc
     */
    public function readData()
    {
        parent::readData();

        // Check for success/error messages from redirects
        if (WCF::getSession()->get('__transactionAddSuccess')) {
            $this->successMessage = WCF::getLanguage()->get('wcf.money.transaction.success.add');
            WCF::getSession()->unregister('__transactionAddSuccess');
        }
        if (WCF::getSession()->get('__transactionDeleteSuccess')) {
            $this->successMessage = WCF::getLanguage()->get('wcf.money.transaction.success.delete');
            WCF::getSession()->unregister('__transactionDeleteSuccess');
        }
        if (WCF::getSession()->get('__transactionAddError')) {
            $this->errorMessage = WCF::getLanguage()->get('wcf.money.transaction.error.add');
            WCF::getSession()->unregister('__transactionAddError');
        }
        if (WCF::getSession()->get('__transactionDeleteError')) {
            $this->errorMessage = WCF::getLanguage()->get('wcf.money.transaction.error.delete');
            WCF::getSession()->unregister('__transactionDeleteError');
        }

        // Load transactions with proper error handling
        $this->loadTransactions();
    }

    /**
     * Loads transactions from database with error handling.
     */
    protected function loadTransactions()
    {
        try {
            $conditionBuilder = new PreparedStatementConditionBuilder();
            $conditionBuilder->add('userID = ?', [WCF::getUser()->userID]);

            $sql = "SELECT      *
                    FROM        wcf" . WCF_N . "_transaction
                    " . $conditionBuilder . "
                    ORDER BY    transactionDate DESC";
            $statement = WCF::getDB()->prepareStatement($sql);
            $statement->execute($conditionBuilder->getParameters());

            $this->transactions = [];
            while ($row = $statement->fetchArray()) {
                $this->transactions[] = new Transaction(null, $row);
            }
        } catch (\Exception $e) {
            // Log the database error
            \wcf\functions\exception\logThrowable($e);

            // Set generic error message for display (don't expose internal details)
            $this->errorMessage = WCF::getLanguage()->get('wcf.money.transaction.error.load');

            // Don't disrupt execution - show empty list instead
            $this->transactions = [];
        }
    }

    /**
     * @inheritDoc
     */
    public function assignVariables()
    {
        parent::assignVariables();

        WCF::getTPL()->assign([
            'transactions' => $this->transactions,
            'successMessage' => $this->successMessage,
            'errorMessage' => $this->errorMessage,
        ]);
    }
}
