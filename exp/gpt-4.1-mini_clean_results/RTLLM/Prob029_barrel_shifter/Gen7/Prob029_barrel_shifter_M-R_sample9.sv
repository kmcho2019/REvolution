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
    // Stage 1 wires (shift by 4)
    wire [7:0] stage1;

    // Instantiate mux2X1 for shift-by-4 stage
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift4
            mux2X1 u_shift4 (
                .d0(in[i]),
                .d1(in[(i+4) % 8]),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2 wires (shift by 2)
    wire [7:0] stage2;

    // Instantiate mux2X1 for shift-by-2 stage
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift2
            mux2X1 u_shift2 (
                .d0(stage1[i]),
                .d1(stage1[(i+2) % 8]),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3 wires (shift by 1)
    wire [7:0] stage3;

    // Instantiate mux2X1 for shift-by-1 stage
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift1
            mux2X1 u_shift1 (
                .d0(stage2[i]),
                .d1(stage2[(i+1) % 8]),
                .sel(ctrl[0]),
                .y(stage3[i])
            );
        end
    endgenerate

    assign out = stage3;

endmodule