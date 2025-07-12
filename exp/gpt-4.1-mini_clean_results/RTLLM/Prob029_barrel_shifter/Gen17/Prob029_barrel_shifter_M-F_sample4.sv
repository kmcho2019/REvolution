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

    // Stage 0: Shift by 4 bits if ctrl[2] = 1
    wire [7:0] stage0;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage0_mux
            // Calculate shifted bit index with wrap-around (rotate left by 4)
            wire shifted_bit = in[(i+4) % 8];
            mux2X1 mux_inst (
                .in0(in[i]),
                .in1(shifted_bit),
                .sel(ctrl[2]),
                .out(stage0[i])
            );
        end
    endgenerate

    // Stage 1: Shift by 2 bits if ctrl[1] = 1
    wire [7:0] stage1;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_mux
            // Rotate left by 2
            wire shifted_bit = stage0[(i+2) % 8];
            mux2X1 mux_inst (
                .in0(stage0[i]),
                .in1(shifted_bit),
                .sel(ctrl[1]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: Shift by 1 bit if ctrl[0] = 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_mux
            // Rotate left by 1
            wire shifted_bit = stage1[(i+1) % 8];
            mux2X1 mux_inst (
                .in0(stage1[i]),
                .in1(shifted_bit),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule