module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    // Level 0: 256 inputs -> 128 outputs
    wire [127:0] level0;
    genvar i;
    generate
        for (i = 0; i < 128; i = i + 1) begin : gen_level0
            assign level0[i] = sel[0] ? in[2*i+1] : in[2*i];
        end
    endgenerate

    // Level 1: 128 -> 64
    wire [63:0] level1;
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_level1
            assign level1[i] = sel[1] ? level0[2*i+1] : level0[2*i];
        end
    endgenerate

    // Level 2: 64 -> 32
    wire [31:0] level2;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_level2
            assign level2[i] = sel[2] ? level1[2*i+1] : level1[2*i];
        end
    endgenerate

    // Level 3: 32 -> 16
    wire [15:0] level3;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_level3
            assign level3[i] = sel[3] ? level2[2*i+1] : level2[2*i];
        end
    endgenerate

    // Level 4: 16 -> 8
    wire [7:0] level4;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_level4
            assign level4[i] = sel[4] ? level3[2*i+1] : level3[2*i];
        end
    endgenerate

    // Level 5: 8 -> 4
    wire [3:0] level5;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_level5
            assign level5[i] = sel[5] ? level4[2*i+1] : level4[2*i];
        end
    endgenerate

    // Level 6: 4 -> 2
    wire [1:0] level6;
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_level6
            assign level6[i] = sel[6] ? level5[2*i+1] : level5[2*i];
        end
    endgenerate

    // Level 7: 2 -> 1 (final output)
    assign out = sel[7] ? level6[1] : level6[0];

endmodule