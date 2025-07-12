// Module TopModule: a simple NOR gate implementation.
module TopModule(
    input  a,
    input  b,
    output out
);
// Perform NOR operation: out is 1 only if both a and b are 0.
assign out = ~(a | b);

endmodule