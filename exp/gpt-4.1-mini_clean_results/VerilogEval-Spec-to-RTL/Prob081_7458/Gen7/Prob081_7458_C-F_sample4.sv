module AndGateN #(parameter WIDTH = 2) (
    input  wire [WIDTH-1:0] in,
    output wire             out
);
    assign out = &in; // Reduction AND
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

    // Local parameters for input group sizes
    localparam P1_WIDTH = 3;
    localparam P2_WIDTH = 2;

    // Intermediate wires for AND gate outputs
    wire and1_p1, and2_p1;
    wire and1_p2, and2_p2;

    // Instantiate 3-input AND gates for p1 output
    AndGateN #(.WIDTH(P1_WIDTH)) and_gate1_p1 (
        .in({p1a, p1b, p1c}),
        .out(and1_p1)
    );

    AndGateN #(.WIDTH(P1_WIDTH)) and_gate2_p1 (
        .in({p1d, p1e, p1f}),
        .out(and2_p1)
    );

    // Instantiate 2-input AND gates for p2 output
    AndGateN #(.WIDTH(P2_WIDTH)) and_gate1_p2 (
        .in({p2a, p2b}),
        .out(and1_p2)
    );

    AndGateN #(.WIDTH(P2_WIDTH)) and_gate2_p2 (
        .in({p2c, p2d}),
        .out(and2_p2)
    );

    // OR the AND gate outputs for final outputs
    assign p1y = and1_p1 | and2_p1;
    assign p2y = and1_p2 | and2_p2;

endmodule