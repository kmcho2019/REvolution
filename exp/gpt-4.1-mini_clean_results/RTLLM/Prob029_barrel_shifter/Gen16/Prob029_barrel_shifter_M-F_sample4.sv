module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1; // after shift by 4 if ctrl[2]
    wire [7:0] stage2; // after shift by 2 if ctrl[1]

    genvar i;

    // Stage 1: shift left by 4 bits if ctrl[2] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : SHIFT4
            wire rot_bit = in[(i + 4) % 8];
            mux2X1 m (
                .a(in[i]),
                .b(rot_bit),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift left by 2 bits if ctrl[1] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : SHIFT2
            wire rot_bit = stage1[(i + 2) % 8];
            mux2X1 m (
                .a(stage1[i]),
                .b(rot_bit),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift left by 1 bit if ctrl[0] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : SHIFT1
            wire rot_bit = stage2[(i + 1) % 8];
            mux2X1 m (
                .a(stage2[i]),
                .b(rot_bit),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule