// Simplified Module TopModule directly implements a NOR gate.
module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a | b);

endmodule