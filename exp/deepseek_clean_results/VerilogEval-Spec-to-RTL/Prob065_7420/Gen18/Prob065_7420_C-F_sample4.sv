module NAND #(parameter WIDTH = 4) (
    input [WIDTH-1:0] in,
    output out
);
    // Most efficient NAND implementation using reduction operator
    assign out = ~&in;
endmodule

module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

    // First 4-input NAND gate
    NAND #(4) nand1 (
        .in({p1a, p1b, p1c, p1d}),
        .out(p1y)
    );

    // Second 4-input NAND gate
    NAND #(4) nand2 (
        .in({p2a, p2b, p2c, p2d}),
        .out(p2y)
    );

endmodule