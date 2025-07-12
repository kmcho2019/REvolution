module mux2X1 (
    input wire d0,
    input wire d1,
    input wire sel,
    output wire y
);
    assign y = sel ? d1 : d0;
endmodule

module barrel_shifter(
    input wire [7:0] in,
    input wire [2:0] ctrl,
    output wire [7:0] out
);

    wire [7:0] stage1, stage2;

    // Stage 1: shift by 4 positions if ctrl[2] is set
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift4
            mux2X1 mux4 (
                .d0(in[i]),
                .d1(in[(i+4) % 8]),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 positions if ctrl[1] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift2
            mux2X1 mux2 (
                .d0(stage1[i]),
                .d1(stage1[(i+2) % 8]),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 position if ctrl[0] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift1
            mux2X1 mux1 (
                .d0(stage2[i]),
                .d1(stage2[(i+1) % 8]),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule