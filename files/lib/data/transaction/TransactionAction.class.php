<?php

namespace wcf\data\transaction;

use wcf\data\AbstractDatabaseObjectAction;
use wcf\system\exception\SystemException;
use wcf\system\WCF;

/**
 * Executes transaction-related actions.
 */
class TransactionAction extends AbstractDatabaseObjectAction
{
    /**
     * @inheritDoc
     */
    protected $className = Transaction::class;

    /**
     * @inheritDoc
     */
    protected $permissionsCreate = ['user.money.canAddTransaction'];

    /**
     * @inheritDoc
     */
    protected $permissionsDelete = ['user.money.canDeleteTransaction'];

    /**
     * @inheritDoc
     */
    protected $permissionsUpdate = ['user.money.canEditTransaction'];

    /**
     * @inheritDoc
     */
    public function create()
    {
        try {
            // Validate and sanitize input data
            $data = $this->parameters['data'];
            
            // Ensure required fields are present
            if (empty($data['amount']) || empty($data['description'])) {
                throw new SystemException('Missing required fields');
            }
            
            // Set default values if not provided
            if (!isset($data['transactionDate'])) {
                $data['transactionDate'] = TIME_NOW;
            }
            
            if (!isset($data['userID'])) {
                $data['userID'] = WCF::getUser()->userID;
            }
            
            // Update parameters with modified data
            $this->parameters['data'] = $data;
            
            // Create the transaction with proper error handling
            $transaction = parent::create();
            
            return $transaction;
        } catch (\Exception $e) {
            // Log the error for debugging
            \wcf\functions\exception\logThrowable($e);
            
            // Re-throw as SystemException with user-friendly message
            throw new SystemException('Failed to create transaction: ' . $e->getMessage(), 0, '', $e);
        }
    }

    /**
     * @inheritDoc
     */
    public function update()
    {
        try {
            parent::update();
        } catch (\Exception $e) {
            // Log the error for debugging
            \wcf\functions\exception\logThrowable($e);
            
            // Re-throw as SystemException with user-friendly message
            throw new SystemException('Failed to update transaction: ' . $e->getMessage(), 0, '', $e);
        }
    }

    /**
     * @inheritDoc
     */
    public function delete()
    {
        try {
            parent::delete();
        } catch (\Exception $e) {
            // Log the error for debugging
            \wcf\functions\exception\logThrowable($e);
            
            // Re-throw as SystemException with user-friendly message
            throw new SystemException('Failed to delete transaction: ' . $e->getMessage(), 0, '', $e);
        }
    }
}
