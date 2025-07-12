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
    // Each level halves the number of signals, starting with 256 inputs.
    // We create arrays of wires for each level's outputs.
    // Level indexing: level 0 handles pairs of bits from 'in' using sel[0],
    // up to level 7 that produces final output using sel[7].

    // Declare wires for each level outputs:
    // Level 0 outputs: 128 bits
    wire [127:0] level0;
    // Level 1 outputs: 64 bits
    wire [63:0]  level1;
    // Level 2 outputs: 32 bits
    wire [31:0]  level2;
    // Level 3 outputs: 16 bits
    wire [15:0]  level3;
    // Level 4 outputs: 8 bits
    wire [7:0]   level4;
    // Level 5 outputs: 4 bits
    wire [3:0]   level5;
    // Level 6 outputs: 2 bits
    wire [1:0]   level6;
    // Level 7 outputs: 1 bit (final out)
    wire         level7;

    genvar i;

    // Level 0: 128 muxes selecting pairs of bits from 'in' based on sel[0]
    generate
        for (i = 0; i < 128; i = i + 1) begin : gen_level0
            Mux2to1 mux0 (
                .in0(in[i*2]),
                .in1(in[i*2+1]),
                .sel(sel[0]),
                .out(level0[i])
            );
        end
    endgenerate

    // Level 1: 64 muxes selecting pairs from level0 based on sel[1]
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_level1
            Mux2to1 mux1 (
                .in0(level0[i*2]),
                .in1(level0[i*2+1]),
                .sel(sel[1]),
                .out(level1[i])
            );
        end
    endgenerate

    // Level 2: 32 muxes selecting pairs from level1 based on sel[2]
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_level2
            Mux2to1 mux2 (
                .in0(level1[i*2]),
                .in1(level1[i*2+1]),
                .sel(sel[2]),
                .out(level2[i])
            );
        end
    endgenerate

    // Level 3: 16 muxes selecting pairs from level2 based on sel[3]
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_level3
            Mux2to1 mux3 (
                .in0(level2[i*2]),
                .in1(level2[i*2+1]),
                .sel(sel[3]),
                .out(level3[i])
            );
        end
    endgenerate

    // Level 4: 8 muxes selecting pairs from level3 based on sel[4]
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_level4
            Mux2to1 mux4 (
                .in0(level3[i*2]),
                .in1(level3[i*2+1]),
                .sel(sel[4]),
                .out(level4[i])
            );
        end
    endgenerate

    // Level 5: 4 muxes selecting pairs from level4 based on sel[5]
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_level5
            Mux2to1 mux5 (
                .in0(level4[i*2]),
                .in1(level4[i*2+1]),
                .sel(sel[5]),
                .out(level5[i])
            );
        end
    endgenerate

    // Level 6: 2 muxes selecting pairs from level5 based on sel[6]
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_level6
            Mux2to1 mux6 (
                .in0(level5[i*2]),
                .in1(level5[i*2+1]),
                .sel(sel[6]),
                .out(level6[i])
            );
        end
    endgenerate

    // Level 7: 1 mux selecting between two inputs from level6 based on sel[7]
    Mux2to1 mux7 (
        .in0(level6[0]),
        .in1(level6[1]),
        .sel(sel[7]),
        .out(level7)
    );

    assign out = level7;

endmodule