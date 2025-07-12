// 2-to-1 multiplexer module for single bit
module mux2X1 (
    input  wire d0,
    input  wire d1,
    input  wire sel,
    output wire y
);
    assign y = sel ? d1 : d0;
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Stage 0: shift by 4 if ctrl[2] = 1
    wire [7:0] stage0_in = in;
    wire [7:0] stage0_shifted;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage0_shift
            // Rotate left by 4: (i + 4) mod 8
            assign stage0_shifted[i] = stage0_in[(i + 4) % 8];
        end
    endgenerate
    wire [7:0] stage0_out;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage0_mux
            mux2X1 mux_inst (
                .d0(stage0_in[i]),
                .d1(stage0_shifted[i]),
                .sel(ctrl[2]),
                .y(stage0_out[i])
            );
        end
    endgenerate

    // Stage 1: shift by 2 if ctrl[1] = 1
    wire [7:0] stage1_in = stage0_out;
    wire [7:0] stage1_shifted;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_shift
            // Rotate left by 2: (i + 2) mod 8
            assign stage1_shifted[i] = stage1_in[(i + 2) % 8];
        end
    endgenerate
    wire [7:0] stage1_out;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_mux
            mux2X1 mux_inst (
                .d0(stage1_in[i]),
                .d1(stage1_shifted[i]),
                .sel(ctrl[1]),
                .y(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: shift by 1 if ctrl[0] = 1
    wire [7:0] stage2_in = stage1_out;
    wire [7:0] stage2_shifted;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_shift
            // Rotate left by 1: (i + 1) mod 8
            assign stage2_shifted[i] = stage2_in[(i + 1) % 8];
        end
    endgenerate
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_mux
            mux2X1 mux_inst (
                .d0(stage2_in[i]),
                .d1(stage2_shifted[i]),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule