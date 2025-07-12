module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Stage 1: shift by 4 bits
    wire [7:0] stage4;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : shift4_stage
            // rotate left by 4 means bit i takes bit (i+4) mod 8 from input when ctrl[2] = 1
            mux2X1 mux4 (
                .d0(in[i]),
                .d1(in[(i+4)%8]),
                .sel(ctrl[2]),
                .y(stage4[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 bits
    wire [7:0] stage2;
    generate
        for (i=0; i<8; i=i+1) begin : shift2_stage
            // rotate left by 2 means bit i takes bit (i+2) mod 8 from previous stage when ctrl[1] = 1
            mux2X1 mux2 (
                .d0(stage4[i]),
                .d1(stage4[(i+2)%8]),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 bit
    wire [7:0] stage1;
    generate
        for (i=0; i<8; i=i+1) begin : shift1_stage
            // rotate left by 1 means bit i takes bit (i+1) mod 8 from previous stage when ctrl[0] = 1
            mux2X1 mux1 (
                .d0(stage2[i]),
                .d1(stage2[(i+1)%8]),
                .sel(ctrl[0]),
                .y(stage1[i])
            );
        end
    endgenerate

    assign out = stage1;

endmodule