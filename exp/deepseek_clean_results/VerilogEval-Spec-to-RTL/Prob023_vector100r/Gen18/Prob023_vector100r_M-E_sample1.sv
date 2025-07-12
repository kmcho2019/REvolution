module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Stage wires for the butterfly network
wire [99:0] stage0, stage1, stage2, stage3, stage4, stage5, stage6;

// Initial assignment
assign stage0 = in;

// Stage 1: Swap adjacent bits (distance 1)
genvar i;
generate
    for (i = 0; i < 100; i = i + 2) begin : stage1_swap
        assign stage1[i]   = (i+1 < 100) ? stage0[i+1] : stage0[i];
        assign stage1[i+1] = stage0[i];
    end
endgenerate

// Stage 2: Swap bits with distance 2
generate
    for (i = 0; i < 100; i = i + 4) begin : stage2_swap
        assign stage2[i]   = (i+2 < 100) ? stage1[i+2] : stage1[i];
        assign stage2[i+1] = (i+3 < 100) ? stage1[i+3] : stage1[i+1];
        assign stage2[i+2] = stage1[i];
        assign stage2[i+3] = stage1[i+1];
    end
endgenerate

// Stage 3: Swap bits with distance 4
generate
    for (i = 0; i < 100; i = i + 8) begin : stage3_swap
        assign stage3[i]   = (i+4 < 100) ? stage2[i+4] : stage2[i];
        assign stage3[i+1] = (i+5 < 100) ? stage2[i+5] : stage2[i+1];
        assign stage3[i+2] = (i+6 < 100) ? stage2[i+6] : stage2[i+2];
        assign stage3[i+3] = (i+7 < 100) ? stage2[i+7] : stage2[i+3];
        assign stage3[i+4] = stage2[i];
        assign stage3[i+5] = stage2[i+1];
        assign stage3[i+6] = stage2[i+2];
        assign stage3[i+7] = stage2[i+3];
    end
endgenerate

// Stage 4: Swap bits with distance 8
generate
    for (i = 0; i < 100; i = i + 16) begin : stage4_swap
        for (genvar j = 0; j < 8; j = j + 1) begin : swap_group
            assign stage4[i+j]   = (i+j+8 < 100) ? stage3[i+j+8] : stage3[i+j];
            assign stage4[i+j+8] = stage3[i+j];
        end
    end
endgenerate

// Stage 5: Swap bits with distance 16
generate
    for (i = 0; i < 100; i = i + 32) begin : stage5_swap
        for (genvar j = 0; j < 16; j = j + 1) begin : swap_group
            assign stage5[i+j]    = (i+j+16 < 100) ? stage4[i+j+16] : stage4[i+j];
            assign stage5[i+j+16] = stage4[i+j];
        end
    end
endgenerate

// Stage 6: Swap bits with distance 32
generate
    for (i = 0; i < 100; i = i + 64) begin : stage6_swap
        for (genvar j = 0; j < 32; j = j + 1) begin : swap_group
            assign stage6[i+j]    = (i+j+32 < 100) ? stage5[i+j+32] : stage5[i+j];
            assign out[i+j+32]    = stage5[i+j];
            assign out[i+j]       = (i+j+32 < 100) ? stage5[i+j+32] : stage5[i+j];
        end
    end
endgenerate

endmodule