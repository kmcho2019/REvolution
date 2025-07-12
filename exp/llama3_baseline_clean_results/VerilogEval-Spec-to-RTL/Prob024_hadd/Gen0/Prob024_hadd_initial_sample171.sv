module TopModule(
    input a,
    input b,
    output sum,
    output cout
);

assign sum = a ^ b; // XOR operator for sum
assign cout = a & b; // AND operator for carry-out

endmodule