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

    // Internal wires representing each AND gate output
    wire and1_p1, and2_p1;
    wire and1_p2, and2_p2;

    // Instantiate 3-input AND gates for p1
    AndGateN #(.WIDTH(3)) and_gate1_p1 (
        .in({p1a, p1b, p1c}),
        .out(and1_p1)
    );

    AndGateN #(.WIDTH(3)) and_gate2_p1 (
        .in({p1d, p1e, p1f}),
        .out(and2_p1)
    );

    // Instantiate 2-input AND gates for p2
    AndGateN #(.WIDTH(2)) and_gate1_p2 (
        .in({p2a, p2b}),
        .out(and1_p2)
    );

    AndGateN #(.WIDTH(2)) and_gate2_p2 (
        .in({p2c, p2d}),
        .out(and2_p2)
    );

    // OR the outputs of the AND gates to produce final outputs
    assign p1y = and1_p1 | and2_p1;
    assign p2y = and1_p2 | and2_p2;

endmodule