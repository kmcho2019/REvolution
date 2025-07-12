module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a ^ b); // XNOR operation is equivalent to NOT XOR

endmodule