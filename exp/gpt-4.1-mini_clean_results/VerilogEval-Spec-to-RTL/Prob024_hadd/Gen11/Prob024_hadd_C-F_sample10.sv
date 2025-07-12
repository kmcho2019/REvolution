module TopModule (
    input  wire a,      // First input bit
    input  wire b,      // Second input bit
    output wire sum,    // Sum output (a XOR b)
    output wire cout    // Carry output (a AND b)
);

// Sum is XOR of inputs
assign sum = a ^ b;

// Carry-out is AND of inputs
assign cout = a & b;

endmodule