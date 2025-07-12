// 2-to-1 Multiplexer module
module mux2X1 (
    input  wire d0,
    input  wire d1,
    input  wire sel,
    output wire y
);
    assign y = sel ? d1 : d0;
endmodule

// Barrel shifter using cascaded mux2X1 modules
module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Stage 1: Shift by 4 bits if ctrl[2] is high
    wire [7:0] stage1;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            // Rotate left by 4 means bit i comes from bit (i-4) mod 8
            // That is, source bit = (i + 4) % 8 (right rotation by 4 is same as left rotation by 4)
            // To rotate left by 4: out[i] = in[(i+4) mod 8]
            // For mux, d0 = in[i], d1 = in[(i+4)%8]
            mux2X1 mux (
                .d0(in[i]),
                .d1(in[(i+4)%8]),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: Shift by 2 bits if ctrl[1] is high
    wire [7:0] stage2;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            // Rotate left by 2: bit i comes from bit (i+2) mod 8
            mux2X1 mux (
                .d0(stage1[i]),
                .d1(stage1[(i+2)%8]),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: Shift by 1 bit if ctrl[0] is high
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_muxes
            // Rotate left by 1: bit i comes from bit (i+1) mod 8
            mux2X1 mux (
                .d0(stage2[i]),
                .d1(stage2[(i+1)%8]),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule