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
    wire [7:0] stage0; // after shift by 4 if ctrl[2] == 1
    wire [7:0] stage1; // after shift by 2 if ctrl[1] == 1
    // stage2 will be output (after shift by 1 if ctrl[0] == 1)

    genvar i;

    // Stage 0: shift by 4 controlled by ctrl[2]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage0_mux
            // shifted bit index (rotate left by 4)
            wire shifted_bit = in[(i + 4) % 8];
            mux2X1 mux_stage0 (
                .in0(in[i]),
                .in1(shifted_bit),
                .sel(ctrl[2]),
                .out(stage0[i])
            );
        end
    endgenerate

    // Stage 1: shift by 2 controlled by ctrl[1]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_mux
            // shifted bit index (rotate left by 2)
            wire shifted_bit = stage0[(i + 2) % 8];
            mux2X1 mux_stage1 (
                .in0(stage0[i]),
                .in1(shifted_bit),
                .sel(ctrl[1]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 1 controlled by ctrl[0]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_mux
            // shifted bit index (rotate left by 1)
            wire shifted_bit = stage1[(i + 1) % 8];
            mux2X1 mux_stage2 (
                .in0(stage1[i]),
                .in1(shifted_bit),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule