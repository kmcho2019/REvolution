module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a ^ b); // Using XOR and inversion to implement XNOR

endmodule