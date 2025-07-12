module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage4, stage2, stage1;
    genvar i;

    // Stage 4: rotate left by 4 if ctrl[2]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage4_gen
            assign stage4[i] = ctrl[2] ? in[(i + 4) % 8] : in[i];
        end
    endgenerate

    // Stage 2: rotate left by 2 if ctrl[1]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_gen
            assign stage2[i] = ctrl[1] ? stage4[(i + 2) % 8] : stage4[i];
        end
    endgenerate

    // Stage 1: rotate left by 1 if ctrl[0]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_gen
            assign stage1[i] = ctrl[0] ? stage2[(i + 1) % 8] : stage2[i];
        end
    endgenerate

    assign out = stage1;

endmodule