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

module Mux8to1 (
    input  wire [7:0] in,
    input  wire [2:0] sel,
    output wire       out
);
    wire [1:0] level1_out;
    // Level 1: two 4-to-1 muxes for lower 6 bits
    Mux4to1 mux4_0 (.in(in[3:0]), .sel(sel[1:0]), .out(level1_out[0]));
    Mux4to1 mux4_1 (.in(in[7:4]), .sel(sel[1:0]), .out(level1_out[1]));
    // Level 2: one 2-to-1 mux selecting between outputs of 4-to-1 muxes
    Mux2to1 mux2_0 (.in(level1_out), .sel(sel[2]), .out(out));
endmodule

module Mux32to1 (
    input  wire [31:0] in,
    input  wire [4:0]  sel,
    output wire        out
);
    // Build 32-to-1 mux as tree of 4-to-1 muxes plus 2-to-1 mux at top:
    // Level 1: eight 4-to-1 muxes (32 inputs to 8 outputs)
    wire [7:0] level1_out;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : level1
            Mux4to1 mux4 (
                .in(in[i*4 +: 4]),
                .sel(sel[1:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: two 4-to-1 muxes (8 inputs to 2 outputs)
    wire [1:0] level2_out;
    Mux4to1 mux4_l2_0 (.in(level1_out[3:0]), .sel(sel[3:2]), .out(level2_out[0]));
    Mux4to1 mux4_l2_1 (.in(level1_out[7:4]), .sel(sel[3:2]), .out(level2_out[1]));

    // Level 3: one 2-to-1 mux (2 inputs to 1 output)
    Mux2to1 mux2_l3 (.in(level2_out), .sel(sel[4]), .out(out));
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    wire [31:0] level1_out;
    // sel[2:0] for 8-to-1 mux at level 1, sel[7:3] for 32-to-1 mux at level 2
    wire [2:0] sel_low = sel[2:0];
    wire [4:0] sel_high = sel[7:3];

    genvar i;
    generate
        // Level 1: 32 instances of 8-to-1 mux selecting among 8 bits each using sel[2:0]
        for (i = 0; i < 32; i = i + 1) begin : level1_muxes
            Mux8to1 mux8 (
                .in(in[i*8 +: 8]),
                .sel(sel_low),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: single 32-to-1 mux selecting among 32 outputs from level1 using sel[7:3]
    Mux32to1 mux32 (
        .in(level1_out),
        .sel(sel_high),
        .out(out)
    );
endmodule