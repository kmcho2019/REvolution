module Mux8to1 (
    input  wire [7:0] in,
    input  wire [2:0] sel,
    output wire       out
);
    // Direct index-based 8-to-1 mux
    assign out = in[sel];
endmodule

module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    // Direct index-based 4-to-1 mux
    assign out = in[sel];
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Level 0: 32 Mux8to1 instances, each selects from 8 bits of 'in' using sel[2:0]
    wire [31:0] level0_out;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_level0
            Mux8to1 mux_inst (
                .in(in[i*8 +: 8]),
                .sel(sel[2:0]),
                .out(level0_out[i])
            );
        end
    endgenerate

    // Level 1: 8 Mux4to1 instances, each selects from 4 bits of level0_out using sel[5:4]
    // Because level0_out has 32 bits, and we need groups of 4 => 32/4=8 muxes.
    wire [7:0] level1_out;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_level1
            Mux4to1 mux_inst (
                .in(level0_out[i*4 +: 4]),
                .sel(sel[5:4]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: 8-to-1 mux selecting from level1_out using sel[7:6 plus one bit?]
    // sel[7:6] are only 2 bits, so 4 options - but we have 8 inputs at level1_out.
    // We need 3 bits to select among 8 inputs, so use sel[7:5].
    // Correct the indexing: sel[7:5] (3 bits) to select among 8 level1_out bits.
    // Therefore, adjust level1 muxes to be 8-to-1 muxes with sel[5:3] to maintain balance.

    // Correction to previous thinking: 
    // Let's fix level 1 muxes to be Mux8to1 (sel[5:3]) with 4 groups of 8 level0_out bits (32 bits total).
    // So level0_out: 32 bits divided into 4 groups of 8 => 4 Mux8to1 muxes.
    // Level1_out: 4 bits.
    // Level2: final 4-to-1 mux with sel[7:6].

    // Re-implement with this fixed hierarchy for cleaner balance:

endmodule

// Final correct balanced hierarchy with three levels:
// Level 0: 32 Mux8to1 muxes, sel[2:0], input: in[255:0]
// Level 1: 4 Mux8to1 muxes, sel[5:3], input: level0_out[31:0]
// Level 2: 1 Mux4to1 mux, sel[7:6], input: level1_out[3:0]

// Let's write the complete corrected code accordingly:

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    wire [31:0] level0_out;
    wire [3:0]  level1_out;

    genvar i;

    // Level 0: 32 Mux8to1 muxes, sel[2:0]
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_level0
            Mux8to1 mux_inst (
                .in(in[i*8 +: 8]),
                .sel(sel[2:0]),
                .out(level0_out[i])
            );
        end
    endgenerate

    // Level 1: 4 Mux8to1 muxes, sel[5:3], each mux selects from 8 bits of level0_out
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_level1
            Mux8to1 mux_inst (
                .in(level0_out[i*8 +: 8]),
                .sel(sel[5:3]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: Final 4-to-1 mux selecting from level1_out with sel[7:6]
    Mux4to1 mux_final (
        .in(level1_out),
        .sel(sel[7:6]),
        .out(out)
    );
endmodule