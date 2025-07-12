module Mux2to1 (
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // We implement an 8-level binary tree of 2-to-1 muxes, reducing 256 inputs to 1 output.
    // At each level i (0..7), the width halves from 2^(8 - i) to 2^(7 - i).
    // level[0] = in (256 bits)
    // level[1] = 128 bits (after muxing pairs at sel[0])
    // ...
    // level[8] = 1 bit output (after muxing pairs at sel[7])

    // Declare an array of wires for intermediate levels
    // Using a 2D vector array indexed as level and element index
    // For synthesis friendliness and Verilog-2001 compatibility, declare as reg arrays or wire arrays

    // Use generate for the iterative tree building

    // Level widths: 256,128,64,32,16,8,4,2,1
    wire [255:0] level0 = in; // inputs

    // Declare wires for each level
    wire [127:0] level1;
    wire [63:0]  level2;
    wire [31:0]  level3;
    wire [15:0]  level4;
    wire [7:0]   level5;
    wire [3:0]   level6;
    wire [1:0]   level7;
    wire         level8;

    genvar i;

    // Level 0 -> Level 1
    generate
        for (i = 0; i < 128; i = i + 1) begin : lvl0_to_lvl1
            Mux2to1 mux2_inst (
                .in0(level0[2*i]),
                .in1(level0[2*i + 1]),
                .sel(sel[0]),
                .out(level1[i])
            );
        end
    endgenerate

    // Level 1 -> Level 2
    generate
        for (i = 0; i < 64; i = i + 1) begin : lvl1_to_lvl2
            Mux2to1 mux2_inst (
                .in0(level1[2*i]),
                .in1(level1[2*i + 1]),
                .sel(sel[1]),
                .out(level2[i])
            );
        end
    endgenerate

    // Level 2 -> Level 3
    generate
        for (i = 0; i < 32; i = i + 1) begin : lvl2_to_lvl3
            Mux2to1 mux2_inst (
                .in0(level2[2*i]),
                .in1(level2[2*i + 1]),
                .sel(sel[2]),
                .out(level3[i])
            );
        end
    endgenerate

    // Level 3 -> Level 4
    generate
        for (i = 0; i < 16; i = i + 1) begin : lvl3_to_lvl4
            Mux2to1 mux2_inst (
                .in0(level3[2*i]),
                .in1(level3[2*i + 1]),
                .sel(sel[3]),
                .out(level4[i])
            );
        end
    endgenerate

    // Level 4 -> Level 5
    generate
        for (i = 0; i < 8; i = i + 1) begin : lvl4_to_lvl5
            Mux2to1 mux2_inst (
                .in0(level4[2*i]),
                .in1(level4[2*i + 1]),
                .sel(sel[4]),
                .out(level5[i])
            );
        end
    endgenerate

    // Level 5 -> Level 6
    generate
        for (i = 0; i < 4; i = i + 1) begin : lvl5_to_lvl6
            Mux2to1 mux2_inst (
                .in0(level5[2*i]),
                .in1(level5[2*i + 1]),
                .sel(sel[5]),
                .out(level6[i])
            );
        end
    endgenerate

    // Level 6 -> Level 7
    generate
        for (i = 0; i < 2; i = i + 1) begin : lvl6_to_lvl7
            Mux2to1 mux2_inst (
                .in0(level6[2*i]),
                .in1(level6[2*i + 1]),
                .sel(sel[6]),
                .out(level7[i])
            );
        end
    endgenerate

    // Level 7 -> Level 8 (final output)
    Mux2to1 mux2_final (
        .in0(level7[0]),
        .in1(level7[1]),
        .sel(sel[7]),
        .out(level8)
    );

    assign out = level8;

endmodule