module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a ^ b); // Directly implementing XNOR using XOR and negation for simplicity and efficiency

endmodule