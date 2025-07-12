module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Stage 1 shift amount controlled by ctrl[2]: shift by 4 if set, else 0
    wire [7:0] stage1;
    wire [7:0] stage2;

    genvar i;

    // Stage 1: shift by 4 controlled by ctrl[2]
    generate
        for (i=0; i<8; i=i+1) begin : stage1_logic
            // Rotate left by 4 bits if ctrl[2]==1
            assign stage1[i] = ctrl[2] ? in[(i+4)%8] : in[i];
        end
    endgenerate

    // Stage 2: shift by 2 controlled by ctrl[1]
    generate
        for (i=0; i<8; i=i+1) begin : stage2_logic
            // Rotate left by 2 bits if ctrl[1]==1
            assign stage2[i] = ctrl[1] ? stage1[(i+2)%8] : stage1[i];
        end
    endgenerate

    // Stage 3: shift by 1 controlled by ctrl[0]
    generate
        for (i=0; i<8; i=i+1) begin : stage3_logic
            // Rotate left by 1 bit if ctrl[0]==1
            assign out[i] = ctrl[0] ? stage2[(i+1)%8] : stage2[i];
        end
    endgenerate

endmodule