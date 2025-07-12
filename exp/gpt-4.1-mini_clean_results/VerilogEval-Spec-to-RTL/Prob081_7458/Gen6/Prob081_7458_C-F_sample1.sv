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

    wire and1_p1, and2_p1;
    wire and1_p2, and2_p2;

    // Instantiate 3-input AND gates for p1 groups
    AndGateN #(3) and_p1_1 (.in({p1a, p1b, p1c}), .out(and1_p1));
    AndGateN #(3) and_p1_2 (.in({p1d, p1e, p1f}), .out(and2_p1));

    // Instantiate 2-input AND gates for p2 groups
    AndGateN #(2) and_p2_1 (.in({p2a, p2b}), .out(and1_p2));
    AndGateN #(2) and_p2_2 (.in({p2c, p2d}), .out(and2_p2));

    // Combine AND gate outputs directly using assign statements
    assign p1y = and1_p1 | and2_p1;
    assign p2y = and1_p2 | and2_p2;

endmodule