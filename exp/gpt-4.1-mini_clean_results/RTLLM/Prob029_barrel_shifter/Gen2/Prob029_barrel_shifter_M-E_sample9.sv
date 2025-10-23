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
    // Stage 1: rotate right by 4 bits if ctrl[2] == 1
    wire [7:0] stage1;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            // shifted bit index for right rotate by 4 is (i + 4) mod 8
            mux2X1 mux4 (
                .in0(in[i]),
                .in1(in[(i+4)%8]),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: rotate right by 2 bits if ctrl[1] == 1
    wire [7:0] stage2;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            // shifted bit index for right rotate by 2 is (i + 2) mod 8
            mux2X1 mux2 (
                .in0(stage1[i]),
                .in1(stage1[(i+2)%8]),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: rotate right by 1 bit if ctrl[0] == 1
    wire [7:0] stage3;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_muxes
            // shifted bit index for right rotate by 1 is (i + 1) mod 8
            mux2X1 mux1 (
                .in0(stage2[i]),
                .in1(stage2[(i+1)%8]),
                .sel(ctrl[0]),
                .out(stage3[i])
            );
        end
    endgenerate

    assign out = stage3;

endmodule