// Basic 2-input AND gate module
module And2 (
    input  a,
    input  b,
    output y
);
    assign y = a & b;
endmodule

// Basic 2-input OR gate module
module Or2 (
    input  a,
    input  b,
    output y
);
    assign y = a | b;
endmodule

// Parameterized reduction AND gate module (supports 2 or 3 inputs)
module AndN #(parameter WIDTH = 2) (
    input  wire [WIDTH-1:0] in,
    output wire             y
);
    assign y = &in;
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

    // Intermediate wires for p1 AND gates (3-input each)
    wire p1_and1_out, p1_and2_out;
    // Intermediate wires for p2 AND gates (2-input each)
    wire p2_and1_out, p2_and2_out;

    // 3-input AND gates for p1 output using reduction AND module
    AndN #(3) and_p1_1 (.in({p1a, p1b, p1c}), .y(p1_and1_out));
    AndN #(3) and_p1_2 (.in({p1d, p1e, p1f}), .y(p1_and2_out));

    // 2-input AND gates for p2 output using primitive module
    And2 and_p2_1 (.a(p2a), .b(p2b), .y(p2_and1_out));
    And2 and_p2_2 (.a(p2c), .b(p2d), .y(p2_and2_out));

    // OR gates for final outputs using primitive OR module
    Or2 or_p1 (.a(p1_and1_out), .b(p1_and2_out), .y(p1y));
    Or2 or_p2 (.a(p2_and1_out), .b(p2_and2_out), .y(p2y));

endmodule