module TopModule(
    input x,
    input y,
    output z
);

// Using a direct NAND gate if available in the synthesis library
assign z = ~(x & y);

endmodule