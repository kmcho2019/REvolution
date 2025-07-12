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

    // Stage 1: shift by 4 positions if ctrl[2]
    wire [7:0] stage1;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_loop
            // calculate shifted index with wrap-around
            wire shifted_bit = in[(i + 4) & 3'b111];
            mux2X1 mux_inst (
                .d0(in[i]),
                .d1(shifted_bit),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 positions if ctrl[1]
    wire [7:0] stage2;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_loop
            wire shifted_bit = stage1[(i + 2) & 3'b111];
            mux2X1 mux_inst (
                .d0(stage1[i]),
                .d1(shifted_bit),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 position if ctrl[0]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_loop
            wire shifted_bit = stage2[(i + 1) & 3'b111];
            mux2X1 mux_inst (
                .d0(stage2[i]),
                .d1(shifted_bit),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule