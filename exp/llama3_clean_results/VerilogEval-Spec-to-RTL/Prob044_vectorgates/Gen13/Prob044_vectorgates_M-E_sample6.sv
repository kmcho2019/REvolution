// Unified Operator Unit (UOU) module
module UnifiedOperatorUnit(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    wire [2:0] inv_a, inv_b;
    wire       a_nonzero, b_nonzero;

    // Inversion
    assign inv_a = ~a;
    assign inv_b = ~b;

    // Bitwise-OR
    assign out_or_bitwise = a | b;

    // Logical-OR (using flags for nonzero detection)
    assign a_nonzero = (a != 3'b000);
    assign b_nonzero = (b != 3'b000);
    assign out_or_logical = a_nonzero || b_nonzero;

    // Output inversion
    assign out_not[5:3] = inv_b;
    assign out_not[2:0] = inv_a;
endmodule

// TopModule
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    UnifiedOperatorUnit u_uou(
        .a(a),
        .b(b),
        .out_or_bitwise(out_or_bitwise),
        .out_or_logical(out_or_logical),
        .out_not(out_not)
    );
endmodule