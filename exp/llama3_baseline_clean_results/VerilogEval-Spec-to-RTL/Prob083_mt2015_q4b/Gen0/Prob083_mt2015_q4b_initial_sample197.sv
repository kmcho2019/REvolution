module TopModule(
    input x,
    input y,
    output z
);

assign z = ~(x ^ y); // XNOR operation using XOR and NOT

endmodule