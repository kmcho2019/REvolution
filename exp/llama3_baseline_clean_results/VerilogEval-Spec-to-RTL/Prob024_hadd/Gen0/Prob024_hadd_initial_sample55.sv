module TopModule(
    input a,
    input b,
    output sum,
    output cout
);

assign sum = a ^ b; // The sum is the XOR of the two inputs
assign cout = a & b; // The carry-out is the AND of the two inputs

endmodule