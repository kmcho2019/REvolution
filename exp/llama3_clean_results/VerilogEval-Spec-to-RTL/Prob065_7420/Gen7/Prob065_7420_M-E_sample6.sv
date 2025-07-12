module NAND(
    parameter WIDTH = 1,
    input  [WIDTH-1:0] a,
    output y
);

    assign y = ~(a == {WIDTH{1'b1}});

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

    wire [3:0] p1 = {p1a, p1b, p1c, p1d};
    wire [3:0] p2 = {p2a, p2b, p2c, p2d};

    NAND #(.WIDTH(4)) nand1(
        .a(p1),
        .y(p1y)
    );

    NAND #(.WIDTH(4)) nand2(
        .a(p2),
        .y(p2y)
    );

endmodule