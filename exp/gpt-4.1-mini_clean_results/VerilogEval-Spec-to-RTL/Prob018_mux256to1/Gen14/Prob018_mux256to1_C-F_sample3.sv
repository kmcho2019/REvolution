module Mux2to1 (
    input  wire [1:0] in,
    input  wire       sel,
    output wire       out
);
    assign out = in[sel];
endmodule

module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    wire [1:0] level1_out;
    // Two 2-to-1 muxes at level 1
    Mux2to1 mux0 (.in(in[1:0]), .sel(sel[0]), .out(level1_out[0]));
    Mux2to1 mux1 (.in(in[3:2]), .sel(sel[0]), .out(level1_out[1]));
    // One 2-to-1 mux at level 2
    Mux2to1 mux2 (.in(level1_out), .sel(sel[1]), .out(out));
endmodule

module Mux16to1 (
    input  wire [15:0] in,
    input  wire [3:0]  sel,
    output wire        out
);
    // Implement 16-to-1 mux as a tree of 4-to-1 muxes and 2-to-1 mux
    wire [3:0] level1_out;

    // Level 1: four 4-to-1 muxes for each group of 4 inputs
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : lvl1_mux
            Mux4to1 mux4 (
                .in(in[i*4 +: 4]),
                .sel(sel[1:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: one 4-to-1 mux selecting among 4 level1 outputs with sel[3:2]
    Mux4to1 mux4_level2 (
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

    wire [15:0] level1_out;
    wire [3:0]  sel_low = sel[3:0];
    wire [3:0]  sel_high = sel[7:4];

    genvar i;
    generate
        // Level 1: sixteen 16-to-1 muxes each selecting 1 bit out of 16 bits, using sel[3:0]
        for (i = 0; i < 16; i = i + 1) begin : level1_muxes
            Mux16to1 mux16 (
                .in(in[i*16 +: 16]),
                .sel(sel_low),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: one 16-to-1 mux selecting from level1 outputs using sel[7:4]
    Mux16to1 mux_final (
        .in(level1_out),
        .sel(sel_high),
        .out(out)
    );

endmodule