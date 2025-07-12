module TopModule(
    input a,
    input b,
    output out
);

assign out = ~(a ^ b); // The XNOR operation can be implemented using the XOR operator (^) and negation (~)

endmodule