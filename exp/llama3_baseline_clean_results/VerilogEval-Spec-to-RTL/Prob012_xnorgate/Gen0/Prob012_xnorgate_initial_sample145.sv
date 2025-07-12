module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a ^ b); // XNOR operation is equivalent to ~(a XOR b)

endmodule