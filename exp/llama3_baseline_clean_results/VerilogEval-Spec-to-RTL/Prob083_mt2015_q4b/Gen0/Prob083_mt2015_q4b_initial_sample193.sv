module TopModule(
    input x,
    input y,
    output z
);

assign z = ~(x ^ y); // Using XOR and negation to implement XNOR

endmodule