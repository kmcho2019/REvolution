module TopModule(
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);

    wire [127:0] stage1;
    wire [63:0]  stage2;
    wire [31:0]  stage3;
    wire [15:0]  stage4;
    wire [7:0]   stage5;
    wire [3:0]   stage6;
    wire [1:0]   stage7;
    wire         stage8;

    // Stage 1: 2-to-1 muxes, select bit sel[0]
    genvar i;
    generate
        for (i=0; i<128; i=i+1) begin : stage1_gen
            assign stage1[i] = sel[0] ? in[2*i+1] : in[2*i];
        end
    endgenerate

    // Stage 2: 2-to-1 muxes, select bit sel[1]
    generate
        for (i=0; i<64; i=i+1) begin : stage2_gen
            assign stage2[i] = sel[1] ? stage1[2*i+1] : stage1[2*i];
        end
    endgenerate

    // Stage 3: select bit sel[2]
    generate
        for (i=0; i<32; i=i+1) begin : stage3_gen
            assign stage3[i] = sel[2] ? stage2[2*i+1] : stage2[2*i];
        end
    endgenerate

    // Stage 4: select bit sel[3]
    generate
        for (i=0; i<16; i=i+1) begin : stage4_gen
            assign stage4[i] = sel[3] ? stage3[2*i+1] : stage3[2*i];
        end
    endgenerate

    // Stage 5: select bit sel[4]
    generate
        for (i=0; i<8; i=i+1) begin : stage5_gen
            assign stage5[i] = sel[4] ? stage4[2*i+1] : stage4[2*i];
        end
    endgenerate

    // Stage 6: select bit sel[5]
    generate
        for (i=0; i<4; i=i+1) begin : stage6_gen
            assign stage6[i] = sel[5] ? stage5[2*i+1] : stage5[2*i];
        end
    endgenerate

    // Stage 7: select bit sel[6]
    generate
        for (i=0; i<2; i=i+1) begin : stage7_gen
            assign stage7[i] = sel[6] ? stage6[2*i+1] : stage6[2*i];
        end
    endgenerate

    // Stage 8: select bit sel[7]
    assign stage8 = sel[7] ? stage7[1] : stage7[0];

    assign out = stage8;

endmodule