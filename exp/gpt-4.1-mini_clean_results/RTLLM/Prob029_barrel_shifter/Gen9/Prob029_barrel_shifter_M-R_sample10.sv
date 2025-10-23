module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    wire [7:0] stage1;  // after shift by 4 controlled by ctrl[2]
    wire [7:0] stage2;  // after shift by 2 controlled by ctrl[1]

    genvar i;

    // Stage 1: rotate right by 4 if ctrl[2] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_assign
            // Compute rotated index for shift by 4 with wrap-around
            // (i - 4) mod 8 = (i >=4) ? i - 4 : i + 4
            wire rotated_bit = (i >= 4) ? in[i - 4] : in[i + 4];
            assign stage1[i] = ctrl[2] ? rotated_bit : in[i];
        end
    endgenerate

    // Stage 2: rotate right by 2 if ctrl[1] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_assign
            // (i - 2) mod 8 = (i >= 2) ? i - 2 : i + 6
            wire rotated_bit = (i >= 2) ? stage1[i - 2] : stage1[i + 6];
            assign stage2[i] = ctrl[1] ? rotated_bit : stage1[i];
        end
    endgenerate

    // Stage 3: rotate right by 1 if ctrl[0] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_assign
            // (i - 1) mod 8 = (i >= 1) ? i - 1 : i + 7
            wire rotated_bit = (i >= 1) ? stage2[i - 1] : stage2[i + 7];
            assign out[i] = ctrl[0] ? rotated_bit : stage2[i];
        end
    endgenerate

endmodule