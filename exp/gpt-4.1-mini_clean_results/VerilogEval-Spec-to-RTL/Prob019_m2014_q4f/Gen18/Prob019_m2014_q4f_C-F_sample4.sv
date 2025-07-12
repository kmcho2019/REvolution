module NotGate (
    input  wire a,
    output wire y
);
    // Simple continuous assignment inverter, synthesis-friendly and minimal
    assign y = ~a;
endmodule

module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Simple continuous assignment AND gate, synthesis-friendly and minimal
    assign y = a & b;
endmodule

module TopModule #(
    parameter STRUCTURAL_IMPL = 0  // 0: direct assign, 1: structural gate-level instantiation
)(
    input  wire in1,
    input  wire in2,
    output wire out
);
    generate
        if (STRUCTURAL_IMPL) begin : gen_structural
            wire not_in2;

            // Explicit inversion of in2 to represent bubble
            NotGate u_not (
                .a(in2),
                .y(not_in2)
            );

            // AND gate combining in1 and inverted in2
            AndGate u_and (
                .a(in1),
                .b(not_in2),
                .y(out)
            );
        end else begin : gen_direct
            // Direct continuous assignment for optimal synthesis mapping
            assign out = in1 & ~in2;
        end
    endgenerate
endmodule