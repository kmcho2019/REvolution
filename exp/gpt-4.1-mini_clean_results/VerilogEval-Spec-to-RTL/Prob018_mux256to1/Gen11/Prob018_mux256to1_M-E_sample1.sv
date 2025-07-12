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
    // We create a balanced binary tree of 2-to-1 muxes, 8 levels deep
    // level_outputs[i] is the wire array of outputs at level i (i=0..7)
    // level -1 is the input vector 'in'

    // Level 0 mux outputs: 128 bits (each mux selects between 2 input bits)
    wire [127:0] level0;
    genvar i, lvl;
    generate
        for (i = 0; i < 128; i = i + 1) begin : LEVEL0
            Mux2to1 u_mux2 (
                .in0(in[2*i]),
                .in1(in[2*i+1]),
                .sel(sel[0]),
                .out(level0[i])
            );
        end
    endgenerate

    // Level 1 mux outputs: 64 bits
    wire [63:0] level1;
    generate
        for (i = 0; i < 64; i = i + 1) begin : LEVEL1
            Mux2to1 u_mux2 (
                .in0(level0[2*i]),
                .in1(level0[2*i+1]),
                .sel(sel[1]),
                .out(level1[i])
            );
        end
    endgenerate

    // Level 2 mux outputs: 32 bits
    wire [31:0] level2;
    generate
        for (i = 0; i < 32; i = i + 1) begin : LEVEL2
            Mux2to1 u_mux2 (
                .in0(level1[2*i]),
                .in1(level1[2*i+1]),
                .sel(sel[2]),
                .out(level2[i])
            );
        end
    endgenerate

    // Level 3 mux outputs: 16 bits
    wire [15:0] level3;
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL3
            Mux2to1 u_mux2 (
                .in0(level2[2*i]),
                .in1(level2[2*i+1]),
                .sel(sel[3]),
                .out(level3[i])
            );
        end
    endgenerate

    // Level 4 mux outputs: 8 bits
    wire [7:0] level4;
    generate
        for (i = 0; i < 8; i = i + 1) begin : LEVEL4
            Mux2to1 u_mux2 (
                .in0(level3[2*i]),
                .in1(level3[2*i+1]),
                .sel(sel[4]),
                .out(level4[i])
            );
        end
    endgenerate

    // Level 5 mux outputs: 4 bits
    wire [3:0] level5;
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL5
            Mux2to1 u_mux2 (
                .in0(level4[2*i]),
                .in1(level4[2*i+1]),
                .sel(sel[5]),
                .out(level5[i])
            );
        end
    endgenerate

    // Level 6 mux outputs: 2 bits
    wire [1:0] level6;
    generate
        for (i = 0; i < 2; i = i + 1) begin : LEVEL6
            Mux2to1 u_mux2 (
                .in0(level5[2*i]),
                .in1(level5[2*i+1]),
                .sel(sel[6]),
                .out(level6[i])
            );
        end
    endgenerate

    // Level 7 mux output: 1 bit (final output)
    Mux2to1 u_final_mux (
        .in0(level6[0]),
        .in1(level6[1]),
        .sel(sel[7]),
        .out(out)
    );

endmodule