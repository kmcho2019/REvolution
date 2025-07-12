module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    // Simple 4-to-1 mux implemented as direct indexing for synthesis friendliness
    assign out = in[sel];
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Level 0: 64 Mux4to1 muxes, each selecting 1 bit from a 4-bit slice of input
    wire [63:0] level0_out;
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : LEVEL0
            Mux4to1 u_mux4_0 (
                .in(in[i*4 +: 4]),
                .sel(sel[1:0]),
                .out(level0_out[i])
            );
        end
    endgenerate

    // Level 1: 16 Mux4to1 muxes selecting from level0_out groups of 4 bits
    wire [15:0] level1_out;
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1
            Mux4to1 u_mux4_1 (
                .in(level0_out[i*4 +: 4]),
                .sel(sel[3:2]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: 4 Mux4to1 muxes selecting from level1_out groups of 4 bits
    wire [3:0] level2_out;
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL2
            Mux4to1 u_mux4_2 (
                .in(level1_out[i*4 +: 4]),
                .sel(sel[5:4]),
                .out(level2_out[i])
            );
        end
    endgenerate

    // Level 3: Final Mux4to1 selecting among the 4 outputs from level2_out
    Mux4to1 u_mux4_final (
        .in(level2_out),
        .sel(sel[7:6]),
        .out(out)
    );
endmodule