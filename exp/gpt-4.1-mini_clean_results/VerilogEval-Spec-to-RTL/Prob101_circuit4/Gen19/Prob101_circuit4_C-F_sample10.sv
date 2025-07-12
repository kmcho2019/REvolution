module OrGate (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = x | y;
endmodule

module TopModule #(
    parameter USE_MODULE = 0
) (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);

    // Prevent synthesis warnings about unused inputs a and d
    wire unused = a ^ d; // XOR dummy use; will be optimized away

    generate
        if (USE_MODULE) begin : mod_or_gate
            OrGate or_inst (
                .x(b),
                .y(c),
                .z(q)
            );
        end else begin : direct_assign
            assign q = b | c;
        end
    endgenerate

endmodule