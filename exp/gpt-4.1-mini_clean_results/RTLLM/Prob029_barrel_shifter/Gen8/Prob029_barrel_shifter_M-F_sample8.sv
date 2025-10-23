module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    wire [7:0] stage4;
    wire [7:0] stage2;

    genvar i;

    // Stage 1: shift by 4 if ctrl[2] = 1
    generate
        for (i=0; i<8; i=i+1) begin : shift4
            // left rotate by 4: new bit i comes from bit (i+4)%8 of input
            assign stage4[i] = ctrl[2] ? in[(i+4)%8] : in[i];
        end
    endgenerate

    // Stage 2: shift by 2 if ctrl[1] = 1
    generate
        for (i=0; i<8; i=i+1) begin : shift2
            // left rotate by 2: new bit i comes from bit (i+2)%8 of stage4
            assign stage2[i] = ctrl[1] ? stage4[(i+2)%8] : stage4[i];
        end
    endgenerate

    // Stage 3: shift by 1 if ctrl[0] = 1
    generate
        for (i=0; i<8; i=i+1) begin : shift1
            // left rotate by 1: new bit i comes from bit (i+1)%8 of stage2
            assign out[i] = ctrl[0] ? stage2[(i+1)%8] : stage2[i];
        end
    endgenerate

endmodule