module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Stage 1: Mask and count bits in parallel
    wire [127:0] stage1;
    genvar i;
    generate
        for (i = 0; i < 128; i = i + 1) begin : STAGE1
            assign stage1[i] = in[i*2] + in[i*2+1];
        end
        // Handle the last bit if odd number (255 is odd)
        wire last_bit = in[254];
    endgenerate

    // Stage 2: Sum adjacent pairs (now counting up to 4)
    wire [63:0] stage2;
    generate
        for (i = 0; i < 64; i = i + 1) begin : STAGE2
            assign stage2[i] = stage1[i*2] + stage1[i*2+1];
        end
    endgenerate

    // Stage 3: Sum adjacent quads (now counting up to 8)
    wire [31:0] stage3;
    generate
        for (i = 0; i < 32; i = i + 1) begin : STAGE3
            assign stage3[i] = stage2[i*2] + stage2[i*2+1];
        end
    endgenerate

    // Stage 4: Sum adjacent octets (now counting up to 16)
    wire [15:0] stage4;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE4
            assign stage4[i] = stage3[i*2] + stage3[i*2+1];
        end
    endgenerate

    // Stage 5: Final reduction with carry-save optimization
    wire [7:0] sum_a = stage4[7:0] + stage4[15:8];
    wire [7:0] sum_b = last_bit;  // Include the last bit from original input

    // Final output
    assign out = sum_a + sum_b;

endmodule