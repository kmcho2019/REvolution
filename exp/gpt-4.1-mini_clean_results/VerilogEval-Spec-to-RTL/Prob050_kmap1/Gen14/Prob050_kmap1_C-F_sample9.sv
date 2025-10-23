// Parameterized 3-input OR gate module with structural implementation
module Or3 #(
    parameter USE_STRUCTURAL = 1  // 0: behavioral, 1: structural implementation with 2-input OR gates
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

module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Implement out = a + b + c with structural OR gates for clarity and optimization
    Or3 #(.USE_STRUCTURAL(1)) or3_inst (
        .x(a),
        .y(b),
        .z(c),
        .q(out)
    );

endmodule