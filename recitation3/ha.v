module ha(a, b, sum, cout);
	input a, b;
	output sum, cout;
	xor xor_ha(sum, a, b);
	and and_ha(cout, a, b);

endmodule