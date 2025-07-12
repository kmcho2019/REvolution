module TopModule(
    input x,
    input y,
    output z
);

assign z = ~(x ^ y); // XNOR gate implementation using XOR and NOT

endmodule