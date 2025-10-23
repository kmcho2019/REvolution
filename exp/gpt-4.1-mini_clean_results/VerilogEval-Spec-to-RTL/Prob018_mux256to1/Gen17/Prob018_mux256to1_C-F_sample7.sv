module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    // Simple 4-to-1 mux implemented as direct indexing for synthesis friendliness
    assign out = in[sel];
endmodule

module Level0Mux (
    input  wire [255:0] in,
    input  wire [1:0]   sel,
    output wire [63:0]  out
);
    // For each group of 4 bits in input, select one bit indexed by sel
    // This produces 64 bits out, each is in[i*4 + sel]
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : GEN_LEVEL0
            assign out[i] = in[i*4 + sel];
        end
    endgenerate
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Level 0: directly select bits with sel[1:0] from each 4-bit group of input
    wire [63:0] level0_out;
    Level0Mux u_level0 (
        .in(in),
        .sel(sel[1:0]),
        .out(level0_out)
    );

    // Level 1: 16 Mux4to1 muxes selecting from level0_out groups of 4 bits
    wire [15:0] level1_out;
    genvar i;
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

    // Level 3: Final Mux4to1 mux selecting from level2_out with sel[7:6]
    Mux4to1 u_mux4_final (
        .in(level2_out),
        .sel(sel[7:6]),
        .out(out)
    );
endmodule