module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    wire [7:0] stage1; // after shift by 4 if ctrl[2]
    wire [7:0] stage2; // after shift by 2 if ctrl[1]

    genvar i;

    // Stage 1: shift left by 4 bits if ctrl[2] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            // Rotate left by 4: bit i gets in[(i+4)%8]
            assign stage1[i] = ctrl[2] ? in[(i+4) & 3'h7] : in[i];
        end
    endgenerate

    // Stage 2: shift left by 2 bits if ctrl[1] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            // Rotate left by 2: bit i gets stage1[(i+2)%8]
            assign stage2[i] = ctrl[1] ? stage1[(i+2) & 3'h7] : stage1[i];
        end
    endgenerate

    // Stage 3: shift left by 1 bit if ctrl[0] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_muxes
            // Rotate left by 1: bit i gets stage2[(i+1)%8]
            assign out[i] = ctrl[0] ? stage2[(i+1) & 3'h7] : stage2[i];
        end
    endgenerate

endmodule