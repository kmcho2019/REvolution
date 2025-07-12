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
    // Two 2-to-1 muxes
    genvar i;
    generate
        for (i = 0; i < 2; i = i + 1) begin : mux2to1_inst
            Mux2to1 mux2 (
                .in(in[i*2 +: 2]),
                .sel(sel[0]),
                .out(level1_out[i])
            );
        end
    endgenerate
    // Final 2-to-1 mux
    Mux2to1 mux2_final (
        .in(level1_out),
        .sel(sel[1]),
        .out(out)
    );
endmodule

module Mux8to1 (
    input  wire [7:0] in,
    input  wire [2:0] sel,
    output wire       out
);
    wire [1:0] level1_out;
    // First layer: two 4-to-1 muxes
    wire [3:0] in0 = in[3:0];
    wire [3:0] in1 = in[7:4];

    wire out0, out1;

    Mux4to1 mux4_0 (
        .in(in0),
        .sel(sel[1:0]),
        .out(out0)
    );
    Mux4to1 mux4_1 (
        .in(in1),
        .sel(sel[1:0]),
        .out(out1)
    );

    // Final 2-to-1 mux
    Mux2to1 mux2_final (
        .in({out1, out0}),
        .sel(sel[2]),
        .out(out)
    );
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    // 256 inputs split into 32 groups of 8 bits
    // Level 1: 32 Mux8to1 muxes selecting bits using sel[2:0]
    wire [31:0] level1_out;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : level1
            Mux8to1 mux8_inst (
                .in(in[i*8 +: 8]),
                .sel(sel[2:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: 32-to-1 mux selecting one of the 32 outputs from level1
    // Implemented as 4 Mux8to1 muxes + 1 Mux4to1 mux

    wire [3:0] level2_out;

    // Four 8-to-1 muxes (each selects one of 8 outputs from level1)
    generate
        for (i = 0; i < 4; i = i + 1) begin : level2_8to1
            Mux8to1 mux8_level2 (
                .in(level1_out[i*8 +: 8]),
                .sel(sel[5:3]),
                .out(level2_out[i])
            );
        end
    endgenerate

    // Final 4-to-1 mux selects among the 4 outputs of above muxes using sel[7:6]
    Mux4to1 mux4_final (
        .in(level2_out),
        .sel(sel[7:6]),
        .out(out)
    );
endmodule