module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    // Simple 4-to-1 mux implemented by direct indexing
    assign out = in[sel];
endmodule

module Mux16to1 (
    input  wire [15:0] in,
    input  wire [3:0]  sel,
    output wire        out
);
    // Implement 16-to-1 mux as a balanced tree of 4-to-1 muxes (two levels)
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
        // Level 0: 16 instances of Mux16to1 selecting from chunks of 16 input bits using sel[3:0]
        for (i = 0; i < 16; i = i + 1) begin : LEVEL0
            Mux16to1 mux16_inst (
                .in(in[i*16 +: 16]),
                .sel(sel[3:0]),
                .out(level0_out[i])
            );
        end
    endgenerate

    // Level 1: single Mux16to1 selecting from 16 outputs of level0 using sel[7:4]
    Mux16to1 mux16_final (
        .in(level0_out),
        .sel(sel[7:4]),
        .out(out)
    );
endmodule