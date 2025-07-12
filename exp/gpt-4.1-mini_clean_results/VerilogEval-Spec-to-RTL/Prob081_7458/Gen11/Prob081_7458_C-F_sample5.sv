module AndGateN #(parameter WIDTH = 2) (
    input  wire [WIDTH-1:0] in,
    output wire             out
);
    // Reduction AND of all input bits
    assign out = &in;
endmodule

module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    // Intermediate wires for each AND gate output
    wire and_p1_group1;
    wire and_p1_group2;
    wire and_p2_group1;
    wire and_p2_group2;

    // Instantiate 3-input AND gates for p1 outputs
    AndGateN #(.WIDTH(3)) and_p1_1 (
        .in({p1a, p1b, p1c}),
        .out(and_p1_group1)
    );

    AndGateN #(.WIDTH(3)) and_p1_2 (
        .in({p1d, p1e, p1f}),
        .out(and_p1_group2)
    );

    // Instantiate 2-input AND gates for p2 outputs
    AndGateN #(.WIDTH(2)) and_p2_1 (
        .in({p2a, p2b}),
        .out(and_p2_group1)
    );

    AndGateN #(.WIDTH(2)) and_p2_2 (
        .in({p2c, p2d}),
        .out(and_p2_group2)
    );

    // Final OR gates producing output
    assign p1y = and_p1_group1 | and_p1_group2;
    assign p2y = and_p2_group1 | and_p2_group2;

endmodule