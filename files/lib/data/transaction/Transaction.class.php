<?php

namespace wcf\data\transaction;

use wcf\data\DatabaseObject;

/**
 * Represents a transaction.
 */
class Transaction extends DatabaseObject
{
    /**
     * @inheritDoc
     */
    protected static $databaseTableName = 'transaction';

    /**
     * @inheritDoc
     */
    protected static $databaseTableIndexName = 'transactionID';
}
