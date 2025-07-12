module TopModule(
    input  a,
    input  b,
    output out
);

assign out = (a == b) ? 1'b1 : 1'b0;

// Alternatively, you could use:
// assign out = ~(a ^ b);

endmodule