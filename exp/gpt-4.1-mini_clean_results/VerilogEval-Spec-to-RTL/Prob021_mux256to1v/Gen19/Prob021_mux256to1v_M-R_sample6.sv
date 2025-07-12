module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Stage 1: 64 groups, each 4 inputs x 4 bits = 16 bits per group
    // Each selects one 4-bit chunk among 4 based on sel[1:0]
    wire [3:0] stage1_out [0:63];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : STAGE1
            // Extract four 4-bit inputs
            wire [3:0] inputs [0:3];
            assign inputs[0] = in[i*16 + 0 +: 4];
            assign inputs[1] = in[i*16 + 4 +: 4];
            assign inputs[2] = in[i*16 + 8 +: 4];
            assign inputs[3] = in[i*16 + 12 +: 4];

            // Select among inputs using sel[1:0]
            assign stage1_out[i] = inputs[sel[1:0]];
        end
    endgenerate

    // Stage 2: 16 groups, each selects 4 of stage1 outputs based on sel[3:2]
    wire [3:0] stage2_out [0:15];
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : STAGE2
            wire [3:0] inputs [0:3];
            assign inputs[0] = stage1_out[j*4 + 0];
            assign inputs[1] = stage1_out[j*4 + 1];
            assign inputs[2] = stage1_out[j*4 + 2];
            assign inputs[3] = stage1_out[j*4 + 3];

            assign stage2_out[j] = inputs[sel[3:2]];
        end
    endgenerate

    // Stage 3: 4 groups, select 4 of stage2 outputs based on sel[5:4]
    wire [3:0] stage3_out [0:3];
    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin : STAGE3
            wire [3:0] inputs [0:3];
            assign inputs[0] = stage2_out[k*4 + 0];
            assign inputs[1] = stage2_out[k*4 + 1];
            assign inputs[2] = stage2_out[k*4 + 2];
            assign inputs[3] = stage2_out[k*4 + 3];

            assign stage3_out[k] = inputs[sel[5:4]];
        end
    endgenerate

    // Stage 4: final mux among 4 stage3 outputs using sel[7:6]
    wire [3:0] inputs_final [0:3];
    assign inputs_final[0] = stage3_out[0];
    assign inputs_final[1] = stage3_out[1];
    assign inputs_final[2] = stage3_out[2];
    assign inputs_final[3] = stage3_out[3];
    assign out = inputs_final[sel[7:6]];

endmodule