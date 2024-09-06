import pandas as pd

# Sample DataFrame creation
data = {
    "BankId": ["A1020"] * 9 + ["A1021"] * 9,
    "AccountID": [
        "S39403030", "S30495345", "S234234432", "C34534543", "C34595044", "C2304985345", "D934530945", 
        "D940404984", "D02340494r", "S3405935845", "S950504840", "S94040958", "C34095345", "C08548494", 
        "C88594048", "D9440021", "D9440021", "D495489"
    ]
}

df = pd.DataFrame(data)

error_records = []
valid_records = []

valid_df = pd.DataFrame(columns=['BankID', 'AccountID'])
error_df = pd.DataFrame(columns=['BankID', 'AccountID', 'Reason'])

account_type_map = {'C': 'Credit', 'S': 'Savings', 'D': 'Deposit'}

for index, row in df.iterrows():
    bank_id = row['BankId']
    account_id = row['AccountID']
    
    if (bank_id, account_id) in valid_records:
        error_records.append((bank_id, account_id, 'Duplicate Record'))
    elif account_id[0] not in account_type_map:
        error_records.append((bank_id, account_id, 'Invalid Account Type'))
    elif not (7 <= len(account_id[1:]) <= 12):
        error_records.append((bank_id, account_id, 'Account Length Violation'))
    elif not account_id[1:].isdigit():
        error_records.append((bank_id, account_id, 'Invalid Account ID Composition'))
    else:
        valid_records.append((bank_id, account_id))
        account_type = account_type_map.get(account_id[0], 'Unknown')
        account_no = account_id[1:]
        valid_df = valid_df.append({'BankID': bank_id, 'AccountID': account_id}, ignore_index=True)

target_df = pd.concat([valid_df['BankID'],
                       pd.DataFrame(valid_df['AccountID'].apply
                                    (lambda x: pd.Series([account_type_map.get(x[0], 'Unknown'),
                                                          int(x[1:])]))),], axis=1)
target_df.columns = ['BankID', 'Account_type', 'Account_no']

print(target_df)
