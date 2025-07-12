module TopModule(
    input a,
    input b,
    output sum,
    output cout
);

assign sum = a ^ b; // XOR of a and b
assign cout = a & b; // AND of a and b

endmodule