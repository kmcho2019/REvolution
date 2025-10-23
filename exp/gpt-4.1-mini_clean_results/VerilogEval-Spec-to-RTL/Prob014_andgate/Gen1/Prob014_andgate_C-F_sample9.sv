module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);

// Output is the logical AND of inputs a and b
assign out = a & b;

endmodule