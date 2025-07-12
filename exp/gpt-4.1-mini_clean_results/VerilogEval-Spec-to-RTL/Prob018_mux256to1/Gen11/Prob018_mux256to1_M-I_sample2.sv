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
    // We'll build a balanced binary mux tree with 8 levels.
    // At each level, half the number of wires from the previous level are muxed.

    // Declare wires for each level of mux outputs.
    // Level 0 inputs: 256 bits, level 1: 128 bits, ..., level 8: 1 bit (final output)
    wire [255:0] level0 = in;
    wire [127:0] level1;
    wire [63:0]  level2;
    wire [31:0]  level3;
    wire [15:0]  level4;
    wire [7:0]   level5;
    wire [3:0]   level6;
    wire [1:0]   level7;
    wire         level8;

    genvar i;

    // Level 1: mux pairs from level0 (256) to level1 (128)
    generate
        for (i = 0; i < 128; i = i + 1) begin : GEN_L1
            Mux2to1 u_mux2to1 (
                .in0(level0[2*i]),
                .in1(level0[2*i+1]),
                .sel(sel[0]),
                .out(level1[i])
            );
        end
    endgenerate

    // Level 2: 128 -> 64
    generate
        for (i = 0; i < 64; i = i + 1) begin : GEN_L2
            Mux2to1 u_mux2to1 (
                .in0(level1[2*i]),
                .in1(level1[2*i+1]),
                .sel(sel[1]),
                .out(level2[i])
            );
        end
    endgenerate

    // Level 3: 64 -> 32
    generate
        for (i = 0; i < 32; i = i + 1) begin : GEN_L3
            Mux2to1 u_mux2to1 (
                .in0(level2[2*i]),
                .in1(level2[2*i+1]),
                .sel(sel[2]),
                .out(level3[i])
            );
        end
    endgenerate

    // Level 4: 32 -> 16
    generate
        for (i = 0; i < 16; i = i + 1) begin : GEN_L4
            Mux2to1 u_mux2to1 (
                .in0(level3[2*i]),
                .in1(level3[2*i+1]),
                .sel(sel[3]),
                .out(level4[i])
            );
        end
    endgenerate

    // Level 5: 16 -> 8
    generate
        for (i = 0; i < 8; i = i + 1) begin : GEN_L5
            Mux2to1 u_mux2to1 (
                .in0(level4[2*i]),
                .in1(level4[2*i+1]),
                .sel(sel[4]),
                .out(level5[i])
            );
        end
    endgenerate

    // Level 6: 8 -> 4
    generate
        for (i = 0; i < 4; i = i + 1) begin : GEN_L6
            Mux2to1 u_mux2to1 (
                .in0(level5[2*i]),
                .in1(level5[2*i+1]),
                .sel(sel[5]),
                .out(level6[i])
            );
        end
    endgenerate

    // Level 7: 4 -> 2
    generate
        for (i = 0; i < 2; i = i + 1) begin : GEN_L7
            Mux2to1 u_mux2to1 (
                .in0(level6[2*i]),
                .in1(level6[2*i+1]),
                .sel(sel[6]),
                .out(level7[i])
            );
        end
    endgenerate

    // Level 8: 2 -> 1 (final output)
    Mux2to1 u_mux2to1_final (
        .in0(level7[0]),
        .in1(level7[1]),
        .sel(sel[7]),
        .out(level8)
    );

    assign out = level8;
endmodule