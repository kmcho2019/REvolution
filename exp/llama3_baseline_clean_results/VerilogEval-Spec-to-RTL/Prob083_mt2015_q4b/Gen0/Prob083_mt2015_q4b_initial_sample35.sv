module TopModule(
    input  x,
    input  y,
    output z
);

assign z = ~(x ^ y); // The XOR operation (^) followed by a negation (~) gives the XNOR operation

endmodule