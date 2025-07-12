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
    wire [7:0] stage1;
    wire [7:0] stage2;

    // Stage 1: shift by 4 if ctrl[2] is 1
    // Rotation by 4 bits: bit i takes from bit (i+4) mod 8
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_mux
            mux2X1 u_mux1 (
                .d0(in[i]),
                .d1(in[(i+4) % 8]),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 if ctrl[1] is 1
    // Rotation by 2 bits: bit i takes from bit (i+2) mod 8 of stage1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_mux
            mux2X1 u_mux2 (
                .d0(stage1[i]),
                .d1(stage1[(i+2) % 8]),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 if ctrl[0] is 1
    // Rotation by 1 bit: bit i takes from bit (i+1) mod 8 of stage2
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_mux
            mux2X1 u_mux3 (
                .d0(stage2[i]),
                .d1(stage2[(i+1) % 8]),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule