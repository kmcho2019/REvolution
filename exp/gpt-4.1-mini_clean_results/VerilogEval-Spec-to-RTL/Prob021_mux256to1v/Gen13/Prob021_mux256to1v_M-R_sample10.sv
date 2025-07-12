module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Stage 1: 16 outputs, each selecting 4 bits from a 64-bit chunk (16 * 4 bits)
    wire [3:0] stage1_out [15:0];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1
            // Slice 64 bits corresponding to 16 4-bit inputs
            wire [63:0] in_chunk = in[i*64 +: 64];
            // Select the 4-bit slice indexed by sel[3:0]
            assign stage1_out[i] = in_chunk[sel[3:0]*4 +: 4];
        end
    endgenerate

    // Stage 2: 4 outputs, each selects 4 bits from 4 stage1 outputs indexed by sel[5:4]
    wire [3:0] stage2_out [3:0];
    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : STAGE2
            // Concatenate 4 stage1 outputs for this group
            wire [15:0] concat_stage1 = {
                stage1_out[j*4 + 3],
                stage1_out[j*4 + 2],
                stage1_out[j*4 + 1],
                stage1_out[j*4 + 0]
            };
            // Select one 4-bit slice indexed by sel[5:4]
            assign stage2_out[j] = concat_stage1[sel[5:4]*4 +: 4];
        end
    endgenerate

    // Stage 3: Final output selects 4 bits from 4 stage2 outputs indexed by sel[7:6]
    wire [15:0] concat_stage2 = {
        stage2_out[3],
        stage2_out[2],
        stage2_out[1],
        stage2_out[0]
    };
    assign out = concat_stage2[sel[7:6]*4 +: 4];

endmodule