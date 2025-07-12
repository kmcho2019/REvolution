// Parameterized 3-input OR gate module with optional structural style
module Or3 #(
    parameter USE_STRUCTURAL = 0  // 0: behavioral assign, 1: structural gates
) (
    input  x,
    input  y,
    input  z,
    output q
);
    generate
        if (USE_STRUCTURAL) begin
            // Structural implementation using two 2-input OR gates
            wire or_xy;
            or u1(or_xy, x, y);
            or u2(q, or_xy, z);
        end else begin
            // Behavioral continuous assignment
            assign q = x | y | z;
        end
    endgenerate
endmodule

// TopModule implements the logic from the given Karnaugh map:
// out = a + b + c
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Instantiate a minimal 3-input OR gate to realize out = a + b + c
    Or3 #(.USE_STRUCTURAL(0)) or3_inst (
        .x(a),
        .y(b),
        .z(c),
        .q(out)
    );

endmodule