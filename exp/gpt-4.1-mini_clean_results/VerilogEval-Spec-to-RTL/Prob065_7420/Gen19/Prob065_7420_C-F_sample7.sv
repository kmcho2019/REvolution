module nand4 #(
    parameter WIDTH = 4
) (
    input  [WIDTH-1:0] a,   // Vector input for generality; WIDTH=4 for 4-input NAND
    output             y    // Output of NAND gate
);
    // 4-input NAND gate: output is low only when all inputs are high
    assign y = ~&a;
endmodule

module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    // Instantiate first 4-input NAND gate (equivalent to first gate on 7420 chip)
    nand4 #(.WIDTH(4)) nand_gate1 (
        .a({p1a, p1b, p1c, p1d}),
        .y(p1y)
    );

    // Instantiate second 4-input NAND gate (equivalent to second gate on 7420 chip)
    nand4 #(.WIDTH(4)) nand_gate2 (
        .a({p2a, p2b, p2c, p2d}),
        .y(p2y)
    );

endmodule