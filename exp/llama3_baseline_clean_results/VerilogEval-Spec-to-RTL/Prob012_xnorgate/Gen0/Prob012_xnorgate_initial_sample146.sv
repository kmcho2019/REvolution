module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a ^ b); // XNOR is equivalent to the inverse of XOR

endmodule