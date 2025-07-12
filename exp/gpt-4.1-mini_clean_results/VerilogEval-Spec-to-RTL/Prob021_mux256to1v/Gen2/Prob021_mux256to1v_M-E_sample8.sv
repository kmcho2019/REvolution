module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Stage 1: 256 inputs of 4 bits -> 64 groups of 4 inputs selected by sel[1:0]
    wire [3:0] stage1 [0:63];
    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin : gen_stage1
            // Inputs indices for stage1 group i:
            // The 4 inputs are at sel[1:0] indices within each group of 4*4 bits.
            wire [3:0] in0 = in[4*(4*i + 0) +:4];
            wire [3:0] in1 = in[4*(4*i + 1) +:4];
            wire [3:0] in2 = in[4*(4*i + 2) +:4];
            wire [3:0] in3 = in[4*(4*i + 3) +:4];

            assign stage1[i] = (sel[1:0] == 2'd0) ? in0 :
                               (sel[1:0] == 2'd1) ? in1 :
                               (sel[1:0] == 2'd2) ? in2 :
                                                    in3;
        end
    endgenerate

    // Stage 2: 64 inputs -> 16 groups of 4 inputs selected by sel[3:2]
    wire [3:0] stage2 [0:15];
    generate
        for (i=0; i<16; i=i+1) begin : gen_stage2
            wire [3:0] s1_0 = stage1[4*i + 0];
            wire [3:0] s1_1 = stage1[4*i + 1];
            wire [3:0] s1_2 = stage1[4*i + 2];
            wire [3:0] s1_3 = stage1[4*i + 3];

            assign stage2[i] = (sel[3:2] == 2'd0) ? s1_0 :
                               (sel[3:2] == 2'd1) ? s1_1 :
                               (sel[3:2] == 2'd2) ? s1_2 :
                                                   s1_3;
        end
    endgenerate

    // Stage 3: 16 inputs -> 4 groups of 4 inputs selected by sel[5:4]
    wire [3:0] stage3 [0:3];
    generate
        for (i=0; i<4; i=i+1) begin : gen_stage3
            wire [3:0] s2_0 = stage2[4*i + 0];
            wire [3:0] s2_1 = stage2[4*i + 1];
            wire [3:0] s2_2 = stage2[4*i + 2];
            wire [3:0] s2_3 = stage2[4*i + 3];

            assign stage3[i] = (sel[5:4] == 2'd0) ? s2_0 :
                               (sel[5:4] == 2'd1) ? s2_1 :
                               (sel[5:4] == 2'd2) ? s2_2 :
                                                   s2_3;
        end
    endgenerate

    // Stage 4: 4 inputs -> 1 output selected by sel[7:6]
    wire [3:0] s3_0 = stage3[0];
    wire [3:0] s3_1 = stage3[1];
    wire [3:0] s3_2 = stage3[2];
    wire [3:0] s3_3 = stage3[3];

    assign out = (sel[7:6] == 2'd0) ? s3_0 :
                 (sel[7:6] == 2'd1) ? s3_1 :
                 (sel[7:6] == 2'd2) ? s3_2 :
                                      s3_3;

endmodule