module AndGateN #(parameter WIDTH = 2) (
    input  wire [WIDTH-1:0] in,
    output wire             out
);
    assign out = &in; // Reduction AND for any WIDTH
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

    wire p1_and1, p1_and2;
    wire p2_and1, p2_and2;

    // 3-input AND gates for p1y groups
    AndGateN #(.WIDTH(3)) and_p1_1 (.in({p1a, p1b, p1c}), .out(p1_and1));
    AndGateN #(.WIDTH(3)) and_p1_2 (.in({p1d, p1e, p1f}), .out(p1_and2));

    // 2-input AND gates for p2y groups
    AndGateN #(.WIDTH(2)) and_p2_1 (.in({p2a, p2b}), .out(p2_and1));
    AndGateN #(.WIDTH(2)) and_p2_2 (.in({p2c, p2d}), .out(p2_and2));

    // OR outputs from AND gate results using direct assign statements
    assign p1y = p1_and1 | p1_and2;
    assign p2y = p2_and1 | p2_and2;

endmodule