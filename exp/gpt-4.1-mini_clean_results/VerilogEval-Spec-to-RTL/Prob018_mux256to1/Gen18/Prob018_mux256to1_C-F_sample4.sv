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
    // Build 16-to-1 mux as two layers of 4-to-1 muxes for low fan-in

    wire [3:0] level1_out;

    genvar i;
    generate
        // First layer: four 4-to-1 muxes selecting 1 bit each from 4 bits
        for (i = 0; i < 4; i = i + 1) begin : L1_MUX4
            Mux4to1 mux4_inst (
                .in(in[i*4 +: 4]),
                .sel(sel[1:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Second layer: one 4-to-1 mux selects final output from four level1 outputs
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
    // Level 0: 16 Mux16to1 muxes select 1 bit from each 16-bit slice using sel[3:0]
    wire [15:0] level0_out;
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL0
            Mux16to1 mux16_inst (
                .in(in[i*16 +: 16]),
                .sel(sel[3:0]),
                .out(level0_out[i])
            );
        end
    endgenerate

    // Level 1: 4 Mux4to1 muxes select from level0_out (16 bits) using sel[5:4]
    wire [3:0] level1_out;
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL1
            Mux4to1 mux4_lvl1 (
                .in(level0_out[i*4 +: 4]),
                .sel(sel[5:4]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: Final Mux4to1 mux selects from level1_out using sel[7:6]
    Mux4to1 mux4_lvl2 (
        .in(level1_out),
        .sel(sel[7:6]),
        .out(out)
    );
endmodule