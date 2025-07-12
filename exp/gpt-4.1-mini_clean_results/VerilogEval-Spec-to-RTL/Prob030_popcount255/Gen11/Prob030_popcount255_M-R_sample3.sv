module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Pad input to 256 bits by adding a zero MSB
    wire [255:0] in_padded = {1'b0, in};

    // Number of input bits after padding
    localparam WIDTH = 256;
    localparam STAGES = $clog2(WIDTH);

    // Intermediate arrays to hold sums at each stage
    // stage_sums[stage][index] width varies: bit width = stage + 1
    // Use two-dimensional packed array - workaround with separate wires per stage

    // Stage 0: width=1, 256 elements (each bit)
    wire [0:0] stage0 [0:WIDTH-1];
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i +1) begin : gen_stage0
            assign stage0[i] = in_padded[i];
        end
    endgenerate

    // Subsequent stages: each stage halves the number of sums,
    // each sum is one bit wider than previous stage (since sum of two n-bit numbers fits in n+1 bits)
    // We'll define wires stage1 .. stage8 (since log2(256)=8)
    // stage1: 128 elements of width 2 bits
    // ...
    // stage8: 1 element of width 9 bits

    // Define each stage's wires
    wire [1:0] stage1 [0:127];
    wire [2:0] stage2 [0:63];
    wire [3:0] stage3 [0:31];
    wire [4:0] stage4 [0:15];
    wire [5:0] stage5 [0:7];
    wire [6:0] stage6 [0:3];
    wire [7:0] stage7 [0:1];
    wire [8:0] stage8 [0:0];

    // Generate stage1 sums (sum pairs from stage0)
    generate
        for (i = 0; i < 128; i = i +1) begin : gen_stage1
            assign stage1[i] = stage0[2*i] + stage0[2*i + 1];
        end
    endgenerate

    // stage2 sums (pairs from stage1)
    generate
        for (i = 0; i < 64; i = i +1) begin : gen_stage2
            assign stage2[i] = stage1[2*i] + stage1[2*i + 1];
        end
    endgenerate

    // stage3 sums
    generate
        for (i = 0; i < 32; i = i +1) begin : gen_stage3
            assign stage3[i] = stage2[2*i] + stage2[2*i + 1];
        end
    endgenerate

    // stage4 sums
    generate
        for (i = 0; i < 16; i = i +1) begin : gen_stage4
            assign stage4[i] = stage3[2*i] + stage3[2*i + 1];
        end
    endgenerate

    // stage5 sums
    generate
        for (i = 0; i < 8; i = i +1) begin : gen_stage5
            assign stage5[i] = stage4[2*i] + stage4[2*i + 1];
        end
    endgenerate

    // stage6 sums
    generate
        for (i = 0; i < 4; i = i +1) begin : gen_stage6
            assign stage6[i] = stage5[2*i] + stage5[2*i + 1];
        end
    endgenerate

    // stage7 sums
    generate
        for (i = 0; i < 2; i = i +1) begin : gen_stage7
            assign stage7[i] = stage6[2*i] + stage6[2*i + 1];
        end
    endgenerate

    // stage8 sums (final)
    assign stage8[0] = stage7[0] + stage7[1];

    // The output count fits in 8 bits (max 255)
    assign out = stage8[0][7:0];

endmodule