module fa(a, b, cin, res, cout);
	//this module will create full adders for me
	input a, b, cin;
	output res, cout;
	
	wire a_xor_b;
	
	wire a_and_b;
	wire cin_and_a_xor_b;
	
	xor xor_1(a_xor_b, a, b);
	xor xor_2(res, a_xor_b, cin);
	
	and and_1(a_and_b, a, b);
	and and_2(cin_and_a_xor_b, cin, a_xor_b);
	
	or or_1(cout, a_and_b, cin_and_a_xor_b);
	
	
endmodule