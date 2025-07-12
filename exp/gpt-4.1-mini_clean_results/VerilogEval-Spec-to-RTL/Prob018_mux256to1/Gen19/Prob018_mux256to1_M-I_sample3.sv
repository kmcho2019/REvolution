module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    // Simple 4-to-1 mux: direct indexing
    assign out = in[sel];
endmodule

module TopModule #(
    parameter FLAT = 0 // 0: hierarchical 4-level 4-to-1 mux tree; 1: flat direct indexing
)(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
generate
    if (FLAT) begin : GEN_FLAT
        // Flat mode: direct indexing by sel
        assign out = in[sel];
    end else begin : GEN_HIER
        // Hierarchical 4-level 4-to-1 mux tree:
        // Level 0: 64 muxes select bits from 4-bit slices using sel[1:0]
        wire [63:0] level0_out;
        genvar i;
        for (i = 0; i < 64; i = i + 1) begin : LEVEL0
            Mux4to1 u_mux4 (
                .in(in[i*4 +: 4]),
                .sel(sel[1:0]),
                .out(level0_out[i])
            );
        end

        // Level 1: 16 muxes select from level0_out groups of 4 using sel[3:2]
        wire [15:0] level1_out;
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1
            Mux4to1 u_mux4 (
                .in(level0_out[i*4 +: 4]),
                .sel(sel[3:2]),
                .out(level1_out[i])
            );
        end

        // Level 2: 4 muxes select from level1_out groups of 4 using sel[5:4]
        wire [3:0] level2_out;
        for (i = 0; i < 4; i = i + 1) begin : LEVEL2
            Mux4to1 u_mux4 (
                .in(level1_out[i*4 +: 4]),
                .sel(sel[5:4]),
                .out(level2_out[i])
            );
        end

        // Level 3: final mux selects from level2_out using sel[7:6]
        Mux4to1 u_mux4_top (
            .in(level2_out),
            .sel(sel[7:6]),
            .out(out)
        );
    end
endgenerate
endmodule