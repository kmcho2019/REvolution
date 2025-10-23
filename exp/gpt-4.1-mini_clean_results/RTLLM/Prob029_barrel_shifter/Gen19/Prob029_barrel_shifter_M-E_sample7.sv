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

    wire [7:0] stage0_out;
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;

    genvar i;

    // Stage 0: shift by 1 bit if ctrl[0] == 1
    // Rotate left by 1 bit: bit i takes in[(i+7) % 8]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage0
            mux2X1 mux_inst (
                .in0(in[i]),
                .in1(in[(i + 7) % 8]),  // rotate left by 1 = shift left by 1 with wrap-around
                .sel(ctrl[0]),
                .out(stage0_out[i])
            );
        end
    endgenerate

    // Stage 1: shift by 2 bits if ctrl[1] == 1
    // Rotate left by 2 bits: bit i takes stage0_out[(i+6) % 8]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1
            mux2X1 mux_inst (
                .in0(stage0_out[i]),
                .in1(stage0_out[(i + 6) % 8]), // rotate left by 2 bits
                .sel(ctrl[1]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: shift by 4 bits if ctrl[2] == 1
    // Rotate left by 4 bits: bit i takes stage1_out[(i+4) % 8]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2
            mux2X1 mux_inst (
                .in0(stage1_out[i]),
                .in1(stage1_out[(i + 4) % 8]), // rotate left by 4 bits
                .sel(ctrl[2]),
                .out(stage2_out[i])
            );
        end
    endgenerate

    assign out = stage2_out;

endmodule