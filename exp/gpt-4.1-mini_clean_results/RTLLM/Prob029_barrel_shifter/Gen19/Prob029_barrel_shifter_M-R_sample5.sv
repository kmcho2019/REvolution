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
    // Stage 0 wires (shift by 4)
    wire [7:0] stage0;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage0_mux
            // Rotate left by 4 with wrap-around: shifted bit is in[(i+4)%8]
            mux2X1 u_mux (
                .in0(in[i]),
                .in1(in[(i + 4) % 8]),
                .sel(ctrl[2]),
                .out(stage0[i])
            );
        end
    endgenerate

    // Stage 1 wires (shift by 2)
    wire [7:0] stage1;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_mux
            // Rotate left by 2 with wrap-around: shifted bit is stage0[(i+2)%8]
            mux2X1 u_mux (
                .in0(stage0[i]),
                .in1(stage0[(i + 2) % 8]),
                .sel(ctrl[1]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2 wires (shift by 1)
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_mux
            // Rotate left by 1 with wrap-around: shifted bit is stage1[(i+1)%8]
            mux2X1 u_mux (
                .in0(stage1[i]),
                .in1(stage1[(i + 1) % 8]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule