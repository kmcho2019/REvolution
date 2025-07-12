module NAND #(parameter WIDTH = 4) (
    input [WIDTH-1:0] in,
    output y
);
    // Most efficient NAND implementation using reduction operator
    assign y = ~&in;
endmodule

module TopModule (
    input p1a, p1b, p1c, p1d,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // First 4-input NAND gate
    NAND #(4) nand1 (
        .in({p1d, p1c, p1b, p1a}),  // Ordered for clarity
        .y(p1y)
    );

    // Second 4-input NAND gate
    NAND #(4) nand2 (
        .in({p2d, p2c, p2b, p2a}),  // Consistent ordering
        .y(p2y)
    );

endmodule