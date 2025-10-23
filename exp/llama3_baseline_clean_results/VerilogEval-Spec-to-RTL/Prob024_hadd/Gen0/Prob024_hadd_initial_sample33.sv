module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

assign sum = a ^ b;  // Calculate sum using XOR operation
assign cout = a & b; // Calculate carry-out using AND operation

endmodule