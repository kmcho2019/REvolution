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

    // Stage 1: shift by 4 positions if ctrl[2] = 1
    wire [7:0] stage1;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_mux
            // Rotate left by 4: bit i selects input bit (i - 4) mod 8
            mux2X1 mux_inst (
                .d0(in[i]),
                .d1(in[(i + 4) % 8]),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 positions if ctrl[1] = 1
    wire [7:0] stage2;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_mux
            // Rotate left by 2: bit i selects stage1 bit (i - 2) mod 8
            mux2X1 mux_inst (
                .d0(stage1[i]),
                .d1(stage1[(i + 2) % 8]),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 position if ctrl[0] = 1
    wire [7:0] stage3;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_mux
            // Rotate left by 1: bit i selects stage2 bit (i - 1) mod 8
            mux2X1 mux_inst (
                .d0(stage2[i]),
                .d1(stage2[(i + 1) % 8]),
                .sel(ctrl[0]),
                .y(stage3[i])
            );
        end
    endgenerate

    assign out = stage3;

endmodule