module TopModule (
    input  wire a,     // First input bit
    input  wire b,     // Second input bit
    output wire sum,   // Sum output (a XOR b)
    output wire cout   // Carry output (a AND b)
);

assign sum = a ^ b;
assign cout = a & b;

endmodule