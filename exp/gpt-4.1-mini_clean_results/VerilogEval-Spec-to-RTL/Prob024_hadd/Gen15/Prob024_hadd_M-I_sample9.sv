module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);

// Half Adder: sum is XOR of inputs, carry out is AND of inputs
assign sum = a ^ b;
assign cout = a & b;

endmodule