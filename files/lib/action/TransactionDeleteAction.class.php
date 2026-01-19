<?php

namespace wcf\action;

use wcf\action\AbstractAction;
use wcf\data\transaction\Transaction;
use wcf\data\transaction\TransactionAction;
use wcf\system\exception\IllegalLinkException;
use wcf\system\exception\SystemException;
use wcf\system\request\LinkHandler;
use wcf\system\WCF;
use wcf\util\HeaderUtil;

/**
 * Handles deleting a transaction.
 */
class TransactionDeleteAction extends AbstractAction
{
    /**
     * @var int
     */
    public $transactionID = 0;

    /**
     * @var Transaction
     */
    public $transaction;

    /**
     * @inheritDoc
     */
    public function readParameters()
    {
        parent::readParameters();

        if (isset($_REQUEST['id'])) {
            $this->transactionID = intval($_REQUEST['id']);
        }

        $this->transaction = new Transaction($this->transactionID);
        if (!$this->transaction->transactionID) {
            throw new IllegalLinkException();
        }
    }

    /**
     * @inheritDoc
     */
    public function execute()
    {
        parent::execute();

        try {
            // Delete the transaction with error handling
            $action = new TransactionAction([$this->transaction], 'delete');
            $action->executeAction();

            $this->executed();

            // Show success message
            WCF::getSession()->register('__transactionDeleteSuccess', true);

            // Proper redirect using HeaderUtil::redirect() back to transaction list
            HeaderUtil::redirect(
                LinkHandler::getInstance()->getLink('TransactionList')
            );
            exit;
        } catch (SystemException $e) {
            // Log the error
            \wcf\functions\exception\logThrowable($e);

            // Show error message
            WCF::getSession()->register('__transactionDeleteError', $e->getMessage());

            // Redirect back to transaction list with error
            HeaderUtil::redirect(
                LinkHandler::getInstance()->getLink('TransactionList')
            );
            exit;
        }
    }
}
