{include file='header' pageTitle='wcf.money.transaction.list'}

<header class="contentHeader">
	<div class="contentHeaderTitle">
		<h1 class="contentTitle">
			<fa-icon size="32" name="wallet"></fa-icon>
			{lang}wcf.money.transaction.list{/lang}
		</h1>
	</div>
	
	<nav class="contentHeaderNavigation">
		<ul>
			<li>
				<a href="{link controller='TransactionAdd'}{/link}" class="button">
					<fa-icon name="plus"></fa-icon>
					<span>{lang}wcf.money.transaction.add{/lang}</span>
				</a>
			</li>
		</ul>
	</nav>
</header>

{if $successMessage}
	<woltlab-core-notice type="success">{$successMessage}</woltlab-core-notice>
{/if}

{if $errorMessage}
	<woltlab-core-notice type="error">{$errorMessage}</woltlab-core-notice>
{/if}

{if $transactions|count}
	<div class="section tabularBox">
		<table class="table">
			<thead>
				<tr>
					<th class="columnDate">{lang}wcf.money.transaction.date{/lang}</th>
					<th class="columnText">{lang}wcf.money.transaction.description{/lang}</th>
					<th class="columnText">{lang}wcf.money.transaction.category{/lang}</th>
					<th class="columnDigits">{lang}wcf.money.transaction.amount{/lang}</th>
					<th class="columnText">{lang}wcf.global.button.options{/lang}</th>
				</tr>
			</thead>
			
			<tbody>
				{foreach from=$transactions item=transaction}
					<tr>
						<td class="columnDate">
							{@$transaction->transactionDate|time}
						</td>
						<td class="columnText">
							{$transaction->description}
						</td>
						<td class="columnText">
							<fa-icon name="tag"></fa-icon>
							{$transaction->category}
						</td>
						<td class="columnDigits">
							{if $transaction->amount > 0}
								<span class="badge green">
									<fa-icon name="arrow-up"></fa-icon>
									+{$transaction->amount|currency}
								</span>
							{else}
								<span class="badge red">
									<fa-icon name="arrow-down"></fa-icon>
									{$transaction->amount|currency}
								</span>
							{/if}
						</td>
						<td class="columnText">
							<a href="{link controller='TransactionDelete' id=$transaction->transactionID}{/link}" 
							   class="button small"
							   onclick="return confirm('{lang}wcf.money.transaction.delete{/lang}?');">
								<fa-icon name="trash"></fa-icon>
								<span>{lang}wcf.money.transaction.delete{/lang}</span>
							</a>
						</td>
					</tr>
				{/foreach}
			</tbody>
		</table>
	</div>
{else}
	<woltlab-core-notice type="info">
		<fa-icon name="info-circle"></fa-icon>
		{lang}wcf.global.noItems{/lang}
	</woltlab-core-notice>
{/if}

{include file='footer'}
