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

    wire [7:0] stage1; // after shift by 4 if ctrl[2] is 1
    wire [7:0] stage2; // after shift by 2 if ctrl[1] is 1
    wire [7:0] stage3; // after shift by 1 if ctrl[0] is 1

    genvar i;

    // Stage 1: shift by 4 positions (rotate left by 4)
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

    // Stage 2: shift by 2 positions (rotate left by 2)
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

    // Stage 3: shift by 1 position (rotate left by 1)
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift1
            mux2X1 mux1 (
                .d0(stage2[i]),
                .d1(stage2[(i+1) % 8]),
                .sel(ctrl[0]),
                .y(stage3[i])
            );
        end
    endgenerate

    assign out = stage3;

endmodule