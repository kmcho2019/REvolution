module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    // Simple 4-to-1 mux using direct indexing
    assign out = in[sel];
endmodule

module Mux16to1 (
    input  wire [15:0] in,
    input  wire [3:0]  sel,
    output wire        out
);
    // 16-to-1 mux implemented as two-level 4-to-1 mux tree
    wire [3:0] level1_out;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : first_stage
            Mux4to1 mux4_inst (
                .in(in[i*4 +: 4]),
                .sel(sel[1:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    Mux4to1 mux4_final (
        .in(level1_out),
        .sel(sel[3:2]),
        .out(out)
    );
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    wire [15:0] level0_out;

    genvar i;
    generate
        // Level 0: 16 instances of Mux16to1 selecting bits within each 16-bit chunk using sel[3:0]
        for (i = 0; i < 16; i = i + 1) begin : LEVEL0
            Mux16to1 mux16_inst (
                .in(in[i*16 +: 16]),
                .sel(sel[3:0]),
                .out(level0_out[i])
            );
        end
    endgenerate

    // Level 1: final selection done by directly indexing level0_out with sel[7:4]
    assign out = level0_out[sel[7:4]];

endmodule