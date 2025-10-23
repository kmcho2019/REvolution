module NandChain #(parameter WIDTH = 4) (
    input  wire [WIDTH-1:0] in,
    output wire             out
);
    wire and_result;
    // AND all bits together using reduction AND
    assign and_result = &in;
    // NAND is negation of AND
    assign out = ~and_result;
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
    // Pack inputs for first 4-input NAND
    wire [3:0] p1_inputs = {p1a, p1b, p1c, p1d};
    // Pack inputs for second 4-input NAND
    wire [3:0] p2_inputs = {p2a, p2b, p2c, p2d};

    NandChain #(4) nand1 (
        .in(p1_inputs),
        .out(p1y)
    );

    NandChain #(4) nand2 (
        .in(p2_inputs),
        .out(p2y)
    );
endmodule