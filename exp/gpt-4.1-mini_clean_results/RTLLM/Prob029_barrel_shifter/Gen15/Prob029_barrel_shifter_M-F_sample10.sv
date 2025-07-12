module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Stage 1: shift by 4 if ctrl[2]
    wire [7:0] stage1;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_loop
            wire bit0 = in[i];
            wire bit4 = in[(i + 4) & 3'b111];
            assign stage1[i] = ctrl[2] ? bit4 : bit0;
        end
    endgenerate

    // Stage 2: shift by 2 if ctrl[1]
    wire [7:0] stage2;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_loop
            wire bit0 = stage1[i];
            wire bit2 = stage1[(i + 2) & 3'b111];
            assign stage2[i] = ctrl[1] ? bit2 : bit0;
        end
    endgenerate

    // Stage 3: shift by 1 if ctrl[0]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_loop
            wire bit0 = stage2[i];
            wire bit1 = stage2[(i + 1) & 3'b111];
            assign out[i] = ctrl[0] ? bit1 : bit0;
        end
    endgenerate

endmodule