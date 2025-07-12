module OrGate (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = x | y;
endmodule

module TopModule #(
    parameter USE_OR_MODULE = 0
) (
    input  wire a,  // unused input
    input  wire b,
    input  wire c,
    input  wire d,  // unused input
    output wire q
);

    generate
        if (USE_OR_MODULE) begin : or_module_inst
            OrGate or_gate_inst (
                .x(b),
                .y(c),
                .z(q)
            );
        end else begin : direct_logic
            assign q = b | c;
        end
    endgenerate

endmodule