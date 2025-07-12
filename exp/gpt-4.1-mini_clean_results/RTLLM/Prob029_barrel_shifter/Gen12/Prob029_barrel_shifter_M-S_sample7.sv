module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1, stage2;

    // Stage 1: rotate left by 4 if ctrl[2] is set
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_loop
            assign stage1[i] = ctrl[2] ? in[(i + 4) % 8] : in[i];
        end
    endgenerate

    // Stage 2: rotate left by 2 if ctrl[1] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_loop
            assign stage2[i] = ctrl[1] ? stage1[(i + 2) % 8] : stage1[i];
        end
    endgenerate

    // Stage 3: rotate left by 1 if ctrl[0] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_loop
            assign out[i] = ctrl[0] ? stage2[(i + 1) % 8] : stage2[i];
        end
    endgenerate

endmodule