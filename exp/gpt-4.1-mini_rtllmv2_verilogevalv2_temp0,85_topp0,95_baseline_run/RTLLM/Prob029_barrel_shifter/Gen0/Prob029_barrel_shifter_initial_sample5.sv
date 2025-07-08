module mux2X1 (
    input wire in0,
    input wire in1,
    input wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module barrel_shifter (
    input wire [7:0] in,
    input wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1;
    wire [7:0] stage2;

    // Stage 1: shift by 4 if ctrl[2] = 1
    // For each bit i, mux selects between in[i] and in[(i+4)%8]
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : stage1_loop
            mux2X1 u_mux (
                .in0(in[i]),
                .in1(in[(i+4)%8]),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 if ctrl[1] = 1
    // For each bit i, mux selects between stage1[i] and stage1[(i+2)%8]
    generate
        for (i=0; i<8; i=i+1) begin : stage2_loop
            mux2X1 u_mux (
                .in0(stage1[i]),
                .in1(stage1[(i+2)%8]),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 if ctrl[0] = 1
    // For each bit i, mux selects between stage2[i] and stage2[(i+1)%8]
    generate
        for (i=0; i<8; i=i+1) begin : stage3_loop
            mux2X1 u_mux (
                .in0(stage2[i]),
                .in1(stage2[(i+1)%8]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule