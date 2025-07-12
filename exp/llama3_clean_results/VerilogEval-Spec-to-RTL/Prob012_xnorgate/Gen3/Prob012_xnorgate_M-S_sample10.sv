// Module implementing an XNOR gate
module TopModule(
    input  a,
    input  b,
    output out
);

// XNOR operation: output is 1 when inputs are the same
assign out = ~(a ^ b);

endmodule