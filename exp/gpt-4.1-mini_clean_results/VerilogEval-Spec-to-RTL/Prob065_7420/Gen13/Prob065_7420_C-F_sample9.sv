module nand4 #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] a,
    output y
);
    // NAND all inputs: output is low only when all inputs are high
    assign y = ~&a; // Reduction AND and then negate
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

    // Instantiate two 4-input NAND gates matching 7420 functionality
    nand4 #(.WIDTH(4)) U7420_1 (
        .a({p1a, p1b, p1c, p1d}),
        .y(p1y)
    );

    nand4 #(.WIDTH(4)) U7420_2 (
        .a({p2a, p2b, p2c, p2d}),
        .y(p2y)
    );

endmodule