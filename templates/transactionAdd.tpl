{include file='header' pageTitle='wcf.money.transaction.add'}

<header class="contentHeader">
	<div class="contentHeaderTitle">
		<h1 class="contentTitle">
			<fa-icon size="32" name="plus-circle"></fa-icon>
			{lang}wcf.money.transaction.add{/lang}
		</h1>
	</div>
	
	<nav class="contentHeaderNavigation">
		<ul>
			<li>
				<a href="{link controller='TransactionList'}{/link}" class="button">
					<fa-icon name="list"></fa-icon>
					<span>{lang}wcf.money.transaction.list{/lang}</span>
				</a>
			</li>
		</ul>
	</nav>
</header>

{if $errorMessage|isset}
	<woltlab-core-notice type="error">{$errorMessage}</woltlab-core-notice>
{/if}

<form method="post" action="{link controller='TransactionAdd'}{/link}">
	<section class="section">
		<h2 class="sectionTitle">{lang}wcf.money.transaction.add{/lang}</h2>
		
		<dl>
			<dt>
				<label for="amount">
					<fa-icon name="dollar-sign"></fa-icon>
					{lang}wcf.money.transaction.amount{/lang}
				</label>
			</dt>
			<dd>
				<input type="number" 
				       id="amount" 
				       name="amount" 
				       value="{$amount|isset ? $amount : ''}" 
				       step="0.01" 
				       required 
				       class="medium">
				<small>{lang}wcf.money.transaction.amount.description{/lang}</small>
			</dd>
		</dl>
		
		<dl>
			<dt>
				<label for="description">
					<fa-icon name="file-text"></fa-icon>
					{lang}wcf.money.transaction.description{/lang}
				</label>
			</dt>
			<dd>
				<input type="text" 
				       id="description" 
				       name="description" 
				       value="{$description|isset ? $description : ''}" 
				       required 
				       class="long">
			</dd>
		</dl>
		
		<dl>
			<dt>
				<label for="category">
					<fa-icon name="tag"></fa-icon>
					{lang}wcf.money.transaction.category{/lang}
				</label>
			</dt>
			<dd>
				<select id="category" name="category" class="medium">
					<option value="income" {if $category|isset && $category == 'income'}selected{/if}>
						<fa-icon name="arrow-up"></fa-icon>
						Income
					</option>
					<option value="expense" {if $category|isset && $category == 'expense'}selected{/if}>
						<fa-icon name="arrow-down"></fa-icon>
						Expense
					</option>
					<option value="savings" {if $category|isset && $category == 'savings'}selected{/if}>
						<fa-icon name="piggy-bank"></fa-icon>
						Savings
					</option>
					<option value="investment" {if $category|isset && $category == 'investment'}selected{/if}>
						<fa-icon name="chart-line"></fa-icon>
						Investment
					</option>
				</select>
			</dd>
		</dl>
	</section>
	
	<div class="formSubmit">
		<button type="submit" class="button buttonPrimary">
			<fa-icon name="save"></fa-icon>
			{lang}wcf.global.button.submit{/lang}
		</button>
	</div>
	
	{csrfToken}
</form>

{include file='footer'}
