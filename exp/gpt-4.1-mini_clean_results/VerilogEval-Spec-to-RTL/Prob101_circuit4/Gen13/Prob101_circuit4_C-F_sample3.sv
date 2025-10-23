module OrGate2 #(
    parameter USE_MODULE = 1
) (
    input  wire x,
    input  wire y,
    output wire z
);
    generate
        if (USE_MODULE) begin
            assign z = x | y;
        end else begin
            // fallback, should never synthesize differently but keeps generate syntax
            assign z = x | y;
        end
    endgenerate
endmodule

module TopModule #(
    parameter USE_OR_MODULE = 0
) (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);

    generate
        if (USE_OR_MODULE) begin : use_module
            OrGate2 #(.USE_MODULE(1)) or_gate_inst (
                .x(b),
                .y(c),
                .z(q)
            );
        end else begin : direct_assign
            assign q = b | c;
        end
    endgenerate

endmodule