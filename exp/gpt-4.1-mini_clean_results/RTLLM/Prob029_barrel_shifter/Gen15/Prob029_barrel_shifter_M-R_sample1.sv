module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Stage 1: shift by 4 if ctrl[2] is set
    wire [7:0] stage1;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift4_assign
            assign stage1[i] = ctrl[2] ? in[(i+4)%8] : in[i];
        end
    endgenerate

    // Stage 2: shift by 2 if ctrl[1] is set
    wire [7:0] stage2;
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift2_assign
            assign stage2[i] = ctrl[1] ? stage1[(i+2)%8] : stage1[i];
        end
    endgenerate

    // Stage 3: shift by 1 if ctrl[0] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift1_assign
            assign out[i] = ctrl[0] ? stage2[(i+1)%8] : stage2[i];
        end
    endgenerate

endmodule