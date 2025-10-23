module TopModule (
    input  a,
    input  b,
    output out
);

// Output is high only when both inputs are low: NOR gate implementation
assign out = ~(a | b);

endmodule