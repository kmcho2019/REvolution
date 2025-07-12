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
    // Stage 1 wires: rotate left by 4 if ctrl[2]
    wire [7:0] stage1;

    genvar i;
    generate
        for (i = 0; i < 8; i = i +1) begin : stage1_muxes
            // rotate-left by 4 means bit i comes from bit (i+4)%8
            mux2X1 mux_inst (
                .in0(in[i]),
                .in1(in[(i+4)%8]),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2 wires: rotate left by 2 if ctrl[1]
    wire [7:0] stage2;

    generate
        for (i = 0; i < 8; i = i +1) begin : stage2_muxes
            // rotate-left by 2 means bit i comes from bit (i+2)%8
            mux2X1 mux_inst (
                .in0(stage1[i]),
                .in1(stage1[(i+2)%8]),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3 wires: rotate left by 1 if ctrl[0]
    wire [7:0] stage3;

    generate
        for (i = 0; i < 8; i = i +1) begin : stage3_muxes
            // rotate-left by 1 means bit i comes from bit (i+1)%8
            mux2X1 mux_inst (
                .in0(stage2[i]),
                .in1(stage2[(i+1)%8]),
                .sel(ctrl[0]),
                .out(stage3[i])
            );
        end
    endgenerate

    assign out = stage3;

endmodule