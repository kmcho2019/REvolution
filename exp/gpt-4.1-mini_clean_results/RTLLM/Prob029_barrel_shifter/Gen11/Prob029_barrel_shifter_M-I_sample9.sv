module mux2X1 (
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1, stage2;

    // Define shift amounts corresponding to ctrl bits
    localparam SHIFT4 = 4;
    localparam SHIFT2 = 2;
    localparam SHIFT1 = 1;

    genvar i;

    // Stage 1: rotate left by 4 if ctrl[2] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            // For rotate-left by 4, bit i comes from (i+4)%8
            mux2X1 mux_inst (
                .in0(in[i]),
                .in1(in[(i + SHIFT4) % 8]),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: rotate left by 2 if ctrl[1] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            // For rotate-left by 2, bit i comes from (i+2)%8
            mux2X1 mux_inst (
                .in0(stage1[i]),
                .in1(stage1[(i + SHIFT2) % 8]),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: rotate left by 1 if ctrl[0] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_muxes
            // For rotate-left by 1, bit i comes from (i+1)%8
            mux2X1 mux_inst (
                .in0(stage2[i]),
                .in1(stage2[(i + SHIFT1) % 8]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule