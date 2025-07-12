module AndGateN #(parameter WIDTH = 2) (
    input  wire [WIDTH-1:0] in,
    output wire             out
);
    assign out = &in; // Reduction AND
endmodule

module TopModule(
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

    // Intermediate wires for the four AND gates
    wire and_p1_abc, and_p1_def;
    wire and_p2_ab,  and_p2_cd;

    // Instantiate 3-input AND gates for p1 outputs
    AndGateN #(.WIDTH(3)) and_gate_p1_abc (
        .in({p1a, p1b, p1c}),
        .out(and_p1_abc)
    );

    AndGateN #(.WIDTH(3)) and_gate_p1_def (
        .in({p1d, p1e, p1f}),
        .out(and_p1_def)
    );

    // Instantiate 2-input AND gates for p2 outputs
    AndGateN #(.WIDTH(2)) and_gate_p2_ab (
        .in({p2a, p2b}),
        .out(and_p2_ab)
    );

    AndGateN #(.WIDTH(2)) and_gate_p2_cd (
        .in({p2c, p2d}),
        .out(and_p2_cd)
    );

    // OR the outputs of the AND gates to produce final outputs
    assign p1y = and_p1_abc | and_p1_def;
    assign p2y = and_p2_ab  | and_p2_cd;

endmodule