module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    // Simple 4-to-1 mux: direct indexing
    assign out = in[sel];
endmodule

module Mux16to1 (
    input  wire [15:0] in,
    input  wire  [3:0] sel,
    output wire        out
);
    // Implement 16-to-1 mux as two-level tree of 4-to-1 muxes

    // Level 0: Four 4-to-1 muxes selecting from in slices of 4 bits using sel[1:0]
    wire [3:0] level0_out;
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL0_16to1
            Mux4to1 u_mux4 (
                .in(in[i*4 +: 4]),
                .sel(sel[1:0]),
                .out(level0_out[i])
            );
        end
    endgenerate

    // Level 1: One 4-to-1 mux selecting among level0_out using sel[3:2]
    Mux4to1 u_mux4_level1 (
        .in(level0_out),
        .sel(sel[3:2]),
        .out(out)
    );
endmodule

module TopModule #(
    parameter FLAT = 0 // 0: hierarchical 2-level mux; 1: flat direct indexing
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
        // Hierarchical mode: two-level mux tree using Mux16to1

        // Level 0: 16 Mux16to1 muxes selecting 1 bit from 16-bit slices using sel[3:0]
        wire [15:0] level0_out;
        genvar i;
        for (i = 0; i < 16; i = i + 1) begin : LEVEL0
            Mux16to1 u_mux16 (
                .in(in[i*16 +: 16]),
                .sel(sel[3:0]),
                .out(level0_out[i])
            );
        end

        // Level 1: 1 Mux16to1 mux selecting among level0_out using sel[7:4]
        Mux16to1 u_mux16_top (
            .in(level0_out),
            .sel(sel[7:4]),
            .out(out)
        );
    end
endgenerate
endmodule