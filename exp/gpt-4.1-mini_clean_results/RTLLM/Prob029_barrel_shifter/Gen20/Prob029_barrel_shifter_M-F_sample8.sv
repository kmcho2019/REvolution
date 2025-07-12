module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Stage 0: shift by 4 bits (rotate left)
    wire [7:0] stage0_shifted;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_shift4
            // Rotate index for shift by 4
            wire rotated_bit = in[(i + 4) % 8];
            assign stage0_shifted[i] = ctrl[2] ? rotated_bit : in[i];
        end
    endgenerate

    // Stage 1: shift by 2 bits (rotate left)
    wire [7:0] stage1_shifted;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_shift2
            wire rotated_bit = stage0_shifted[(i + 2) % 8];
            assign stage1_shifted[i] = ctrl[1] ? rotated_bit : stage0_shifted[i];
        end
    endgenerate

    // Stage 2: shift by 1 bit (rotate left)
    wire [7:0] stage2_shifted;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_shift1
            wire rotated_bit = stage1_shifted[(i + 1) % 8];
            assign stage2_shifted[i] = ctrl[0] ? rotated_bit : stage1_shifted[i];
        end
    endgenerate

    assign out = stage2_shifted;

endmodule