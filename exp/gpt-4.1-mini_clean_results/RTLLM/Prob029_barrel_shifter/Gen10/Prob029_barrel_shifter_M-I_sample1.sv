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

    // Stage 1: shift by 4 controlled by ctrl[2]
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            // Calculate rotated index for 4-bit shift (rotate left)
            // Rotate left by 4 means bit i comes from (i+4) mod 8
            mux2X1 mux_inst (
                .in0(in[i]),
                .in1(in[(i + 4) % 8]),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 controlled by ctrl[1]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            // Rotate left by 2: bit i comes from (i+2)%8
            mux2X1 mux_inst (
                .in0(stage1[i]),
                .in1(stage1[(i + 2) % 8]),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 controlled by ctrl[0]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_muxes
            // Rotate left by 1: bit i comes from (i+1)%8
            mux2X1 mux_inst (
                .in0(stage2[i]),
                .in1(stage2[(i + 1) % 8]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule