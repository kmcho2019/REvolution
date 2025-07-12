module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

// sum is XOR of inputs
assign sum = a ^ b;
// cout is AND of inputs
assign cout = a & b;

endmodule