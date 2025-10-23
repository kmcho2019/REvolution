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
    // Define wires for each level outputs as arrays
    wire [63:0] level0_out;
    wire [15:0] level1_out;
    wire [3:0]  level2_out;

    genvar i;

    // Level 0: 64 instances of 4-to-1 muxes, each selecting from 4 bits of 'in' using sel[1:0]
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_level0
            Mux4to1 mux_inst (
                .in(in[i*4 +: 4]),
                .sel(sel[1:0]),
                .out(level0_out[i])
            );
        end
    endgenerate

    // Level 1: 16 instances of 4-to-1 muxes, selecting among groups of 4 bits from level0_out, sel[3:2]
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_level1
            Mux4to1 mux_inst (
                .in(level0_out[i*4 +: 4]),
                .sel(sel[3:2]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: 4 instances of 4-to-1 muxes, selecting among groups of 4 bits from level1_out, sel[5:4]
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_level2
            Mux4to1 mux_inst (
                .in(level1_out[i*4 +: 4]),
                .sel(sel[5:4]),
                .out(level2_out[i])
            );
        end
    endgenerate

    // Level 3: Final 4-to-1 mux selecting from level2_out with sel[7:6]
    Mux4to1 mux_final (
        .in(level2_out),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule