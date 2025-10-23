module TopModule(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

// Direct implementation of full adder logic within TopModule
// to minimize unnecessary hierarchy and potential area overhead
assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule