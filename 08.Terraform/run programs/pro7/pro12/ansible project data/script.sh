ansible-playbook test.yml  | grep 2377 > tk.txt
grep -v stdout tk.txt  > token.sh
rm -rvf tk.txt
