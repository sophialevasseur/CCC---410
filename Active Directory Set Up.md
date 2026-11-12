# Change the Hostname of the Machine
1. Go to settings
2. On the System page, click Rename: 
3. Restart your computer to set the reconfiguration: 
<img width="443" height="201" alt="image" src="https://github.com/user-attachments/assets/afd8c780-5546-4ed4-aa70-66598ec47bdb" />

# Installing the ADDS Role
 1. Open Server Manager and Select Add Roles and Features
 * Before you begin → Click Next
 * Installation type → Click Next (default role-based)
 * Server Selection → Click Next (ensure your ad01-vela is selected)
 * Server Roles → Select Active Directory Domain Services → Add Features → Next
 * Features → Click _Next _
 * AD/DS → Click Next
 * Confirmation → Install
 <img width="443" height="316" alt="image" src="https://github.com/user-attachments/assets/9ade9f68-95b8-4059-be81-6940f6d56322" />

# Configuring the Domain Controller:
1. Once installed, click the option that says Promote this server to a domain controller
   <img width="449" height="218" alt="image" src="https://github.com/user-attachments/assets/a8a7ea37-6063-42c5-866b-8f56a970b965" />

 * Deployment Configuration → Select Add a New Forest and next to root domain name type vela.local
 * Domain Controller Options → Under the password field, create and confirm a new password → Click Next
 * DNS Options → Click Next
 * Additional options → Your name should pop up like this:
