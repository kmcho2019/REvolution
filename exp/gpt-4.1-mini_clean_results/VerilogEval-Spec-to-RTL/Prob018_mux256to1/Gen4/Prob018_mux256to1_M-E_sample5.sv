module TwoToOneMux(
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    // Intermediate wires for each level:
    // Level 0 has 256 inputs, after 1st muxing 128 outputs, after 2nd level 64, etc. until 1 output.
    // Declare arrays to hold the intermediate outputs of each level.
    wire [255:0] level0 = in;
    // Subsequent levels: 128, 64, 32, 16, 8, 4, 2, 1 wires respectively.
    wire [127:0] level1;
    wire [63:0]  level2;
    wire [31:0]  level3;
    wire [15:0]  level4;
    wire [7:0]   level5;
    wire [3:0]   level6;
    wire [1:0]   level7;
    wire         level8;

    genvar i;

    // Level 1: 256 -> 128 muxes
    generate
        for (i = 0; i < 128; i = i + 1) begin : gen_level1
            TwoToOneMux mux (
                .in0(level0[2*i]),
                .in1(level0[2*i+1]),
                .sel(sel[0]),
                .out(level1[i])
            );
        end
    endgenerate

    // Level 2: 128 -> 64 muxes
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_level2
            TwoToOneMux mux (
                .in0(level1[2*i]),
                .in1(level1[2*i+1]),
                .sel(sel[1]),
                .out(level2[i])
            );
        end
    endgenerate

    // Level 3: 64 -> 32 muxes
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_level3
            TwoToOneMux mux (
                .in0(level2[2*i]),
                .in1(level2[2*i+1]),
                .sel(sel[2]),
                .out(level3[i])
            );
        end
    endgenerate

    // Level 4: 32 -> 16 muxes
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_level4
            TwoToOneMux mux (
                .in0(level3[2*i]),
                .in1(level3[2*i+1]),
                .sel(sel[3]),
                .out(level4[i])
            );
        end
    endgenerate

    // Level 5: 16 -> 8 muxes
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_level5
            TwoToOneMux mux (
                .in0(level4[2*i]),
                .in1(level4[2*i+1]),
                .sel(sel[4]),
                .out(level5[i])
            );
        end
    endgenerate

    // Level 6: 8 -> 4 muxes
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_level6
            TwoToOneMux mux (
                .in0(level5[2*i]),
                .in1(level5[2*i+1]),
                .sel(sel[5]),
                .out(level6[i])
            );
        end
    endgenerate

    // Level 7: 4 -> 2 muxes
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_level7
            TwoToOneMux mux (
                .in0(level6[2*i]),
                .in1(level6[2*i+1]),
                .sel(sel[6]),
                .out(level7[i])
            );
        end
    endgenerate

    // Level 8: final 2 -> 1 mux
    TwoToOneMux mux_last (
        .in0(level7[0]),
        .in1(level7[1]),
        .sel(sel[7]),
        .out(out)
    );

endmodule