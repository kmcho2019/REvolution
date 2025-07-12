module NotGate #(parameter DELAY = 0) (
    input  wire a,
    output wire y
);
    // Structural inversion with optional delay for clarity and synthesis friendliness
    assign #(DELAY) y = ~a;
endmodule

module AndGate #(parameter DELAY = 0) (
    input  wire a,
    input  wire b,
    output wire y
);
    // Structural AND with optional delay for clarity and synthesis friendliness
    assign #(DELAY) y = a & b;
endmodule

module TopModule #(
    parameter STRUCTURAL_IMPL = 0  // 0: direct assign, 1: gate instantiation
)(
    input  wire in1,
    input  wire in2,
    output wire out
);
    generate
        if (STRUCTURAL_IMPL) begin : gen_structural
            wire not_in2;
            // Instantiate NotGate for bubble on in2
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
        end else begin : gen_direct
            // Direct continuous assignment for best synthesis optimization
            assign out = in1 & ~in2;
        end
    endgenerate
endmodule