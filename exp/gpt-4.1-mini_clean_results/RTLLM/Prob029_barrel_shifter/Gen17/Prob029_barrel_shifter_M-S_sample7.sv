module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Stage 1: shift by 4 bits if ctrl[2]
    wire [7:0] stage1;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_loop
            assign stage1[i] = ctrl[2] ? in[(i + 8 - 4) % 8] : in[i];
        end
    endgenerate

    // Stage 2: shift by 2 bits if ctrl[1]
    wire [7:0] stage2;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_loop
            assign stage2[i] = ctrl[1] ? stage1[(i + 8 - 2) % 8] : stage1[i];
        end
    endgenerate

    // Stage 3: shift by 1 bit if ctrl[0]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_loop
            assign out[i] = ctrl[0] ? stage2[(i + 8 - 1) % 8] : stage2[i];
        end
    endgenerate

endmodule