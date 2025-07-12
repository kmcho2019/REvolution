module TopModule(
    input x,
    input y,
    output z
);

// Direct NAND implementation
assign z = ~(x & y);

endmodule