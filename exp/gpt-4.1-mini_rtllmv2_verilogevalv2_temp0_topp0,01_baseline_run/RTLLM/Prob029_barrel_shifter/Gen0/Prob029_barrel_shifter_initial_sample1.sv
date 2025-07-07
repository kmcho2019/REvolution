module mux2X1(
    input wire in0,
    input wire in1,
    input wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module barrel_shifter(
    input wire [7:0] in,
    input wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1; // after shift by 4 if ctrl[2] is set
    wire [7:0] stage2; // after shift by 2 if ctrl[1] is set

    // Stage 1: shift by 4 positions if ctrl[2] == 1
    // Rotate left by 4: bit i comes from bit (i+4)%8
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : stage1_mux
            mux2X1 mux4(
                .in0(in[i]),
                .in1(in[(i+4)%8]),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 positions if ctrl[1] == 1
    // Rotate left by 2: bit i comes from bit (i+2)%8
    generate
        for (i=0; i<8; i=i+1) begin : stage2_mux
            mux2X1 mux2(
                .in0(stage1[i]),
                .in1(stage1[(i+2)%8]),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 position if ctrl[0] == 1
    // Rotate left by 1: bit i comes from bit (i+1)%8
    generate
        for (i=0; i<8; i=i+1) begin : stage3_mux
            mux2X1 mux1(
                .in0(stage2[i]),
                .in1(stage2[(i+1)%8]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule