module FourInputNAND (
    input [3:0] in,
    output out
);
    // Most efficient 4-input NAND implementation
    assign out = ~&in;
endmodule

module TopModule (
    input p1a, p1b, p1c, p1d,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // First NAND gate with explicit instance name
    FourInputNAND nand1 (
        .in({p1a, p1b, p1c, p1d}),
        .out(p1y)
    );

    // Second NAND gate with explicit instance name
    FourInputNAND nand2 (
        .in({p2a, p2b, p2c, p2d}),
        .out(p2y)
    );
endmodule