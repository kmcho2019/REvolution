module TopModule(
    input  a,      // First input bit
    input  b,      // Second input bit
    output sum,    // Sum output (a XOR b)
    output cout    // Carry output (a AND b)
);

// Half adder implementation using direct continuous assignments for minimal area and power.
// sum = a XOR b
// cout = a AND b

assign sum = a ^ b;
assign cout = a & b;

endmodule