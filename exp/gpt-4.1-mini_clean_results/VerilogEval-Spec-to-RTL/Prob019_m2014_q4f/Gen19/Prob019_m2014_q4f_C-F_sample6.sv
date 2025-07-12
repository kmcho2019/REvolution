module NotGate (
    input  wire a,
    output wire y
);
    // Minimal inverter module for structural usage
    assign y = ~a;
endmodule

module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Minimal AND gate module for structural usage
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
        if (STRUCTURAL_IMPL) begin : structural_impl
            wire not_in2;

            // Explicitly instantiate NotGate to invert in2 (bubble)
            NotGate u_not (
                .a(in2),
                .y(not_in2)
            );

            // Instantiate AndGate with in1 and inverted in2
            AndGate u_and (
                .a(in1),
                .b(not_in2),
                .y(out)
            );
        end else begin : direct_assign
            // Direct logic expression for optimal synthesis
            assign out = in1 & ~in2;
        end
    endgenerate

endmodule