<?php

namespace wcf\action\transaction;

use wcf\action\AbstractAction;
use wcf\data\transaction\TransactionAction;
use wcf\system\exception\IllegalLinkException;
use wcf\system\exception\SystemException;
use wcf\system\request\LinkHandler;
use wcf\system\WCF;
use wcf\util\HeaderUtil;
use wcf\util\StringUtil;

/**
 * Handles adding a new transaction.
 */
class TransactionAddAction extends AbstractAction
{
    /**
     * @var float
     */
    public $amount = 0.0;

    /**
     * @var string
     */
    public $description = '';

    /**
     * @var string
     */
    public $category = '';

    /**
     * @inheritDoc
     */
    public function readParameters()
    {
        parent::readParameters();

        if (isset($_POST['amount'])) {
            $this->amount = floatval($_POST['amount']);
        }
        if (isset($_POST['description'])) {
            $this->description = StringUtil::trim($_POST['description']);
        }
        if (isset($_POST['category'])) {
            $this->category = StringUtil::trim($_POST['category']);
        }
    }

    /**
     * @inheritDoc
     */
    public function execute()
    {
        parent::execute();

        try {
            // Create the transaction with error handling
            $action = new TransactionAction([], 'create', [
                'data' => [
                    'userID' => WCF::getUser()->userID,
                    'amount' => $this->amount,
                    'description' => $this->description,
                    'category' => $this->category,
                    'transactionDate' => TIME_NOW,
                ],
            ]);
            $action->executeAction();

            $this->executed();

            // Show success message
            WCF::getSession()->register('__transactionAddSuccess', true);

            // Proper redirect using HeaderUtil::redirect() to the transaction list page
            HeaderUtil::redirect(
                LinkHandler::getInstance()->getLink('TransactionList')
            );
            exit;
        } catch (SystemException $e) {
            // Log the error
            \wcf\functions\exception\logThrowable($e);

            // Show error message
            WCF::getSession()->register('__transactionAddError', $e->getMessage());

            // Redirect back to the add form with error
            HeaderUtil::redirect(
                LinkHandler::getInstance()->getLink('TransactionAdd')
            );
            exit;
        }
    }
}
