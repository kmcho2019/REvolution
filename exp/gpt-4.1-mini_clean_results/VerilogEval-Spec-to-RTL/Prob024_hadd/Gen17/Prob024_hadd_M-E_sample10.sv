module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

assign sum  = a ^ b;   // sum is XOR of a and b
assign cout = a & b;   // carry out is AND of a and b

endmodule