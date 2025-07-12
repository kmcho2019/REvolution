module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Stage 1: shift by 4 bits if ctrl[2] == 1
    wire [7:0] stage1_rotated = {in[3:0], in[7:4]};
    wire [7:0] stage1;
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : stage1_mux
            mux2X1 mux_inst (
                .d0(in[i]),
                .d1(stage1_rotated[i]),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 bits if ctrl[1] == 1
    wire [7:0] stage2_rotated = {stage1[1:0], stage1[7:2]};
    wire [7:0] stage2;
    generate
        for (i=0; i<8; i=i+1) begin : stage2_mux
            mux2X1 mux_inst (
                .d0(stage1[i]),
                .d1(stage2_rotated[i]),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 bit if ctrl[0] == 1
    wire [7:0] stage3_rotated = {stage2[0], stage2[7:1]};
    generate
        for (i=0; i<8; i=i+1) begin : stage3_mux
            mux2X1 mux_inst (
                .d0(stage2[i]),
                .d1(stage3_rotated[i]),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule