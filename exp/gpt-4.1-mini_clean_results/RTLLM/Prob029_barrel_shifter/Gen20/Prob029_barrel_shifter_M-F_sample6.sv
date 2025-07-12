// 2-to-1 multiplexer module for 1-bit inputs
module mux2X1 (
    input  wire d0,
    input  wire d1,
    input  wire sel,
    output wire y
);
    assign y = sel ? d1 : d0;
endmodule


module barrel_shifter (
    input  wire [7:0] in,       // 8-bit input to shift/rotate
    input  wire [2:0] ctrl,     // control bits: ctrl[2]=shift by 4, ctrl[1]=shift by 2, ctrl[0]=shift by 1
    output wire [7:0] out       // 8-bit rotated output
);

    wire [7:0] stage1;  // output after shifting by 4 if ctrl[2]
    wire [7:0] stage2;  // output after shifting by 2 if ctrl[1]
    wire [7:0] stage3;  // output after shifting by 1 if ctrl[0]

    genvar i;

    // Stage 1: shift/rotate by 4 if ctrl[2] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_shift4
            // bit rotated by 4 positions to the left (mod 8)
            wire d1 = in[(i + 4) % 8];
            mux2X1 mux_inst (
                .d0(in[i]),
                .d1(d1),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift/rotate by 2 if ctrl[1] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_shift2
            // rotate stage1 output by 2 to the left if ctrl[1]
            wire d1 = stage1[(i + 2) % 8];
            mux2X1 mux_inst (
                .d0(stage1[i]),
                .d1(d1),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift/rotate by 1 if ctrl[0] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_shift1
            // rotate stage2 output by 1 to the left if ctrl[0]
            wire d1 = stage2[(i + 1) % 8];
            mux2X1 mux_inst (
                .d0(stage2[i]),
                .d1(d1),
                .sel(ctrl[0]),
                .y(stage3[i])
            );
        end
    endgenerate

    assign out = stage3;

endmodule