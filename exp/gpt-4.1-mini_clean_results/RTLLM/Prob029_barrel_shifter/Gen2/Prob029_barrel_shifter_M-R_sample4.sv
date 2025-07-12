module mux2X1(
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
    // Stage 1: Shift by 4 bits if ctrl[2] = 1
    wire [7:0] stage1;
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : shift4_mux
            // Calculate shifted bit index with rotation by 4
            // rotate right by 4 means bit (i+4) mod 8
            wire shifted_bit = in[(i+4) % 8];
            mux2X1 m4(
                .d0(in[i]),
                .d1(shifted_bit),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: Shift by 2 bits if ctrl[1] = 1
    wire [7:0] stage2;
    generate
        for(i=0; i<8; i=i+1) begin : shift2_mux
            // rotate right by 2 means bit (i+2) mod 8
            wire shifted_bit = stage1[(i+2) % 8];
            mux2X1 m2(
                .d0(stage1[i]),
                .d1(shifted_bit),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: Shift by 1 bit if ctrl[0] = 1
    wire [7:0] stage3;
    generate
        for(i=0; i<8; i=i+1) begin : shift1_mux
            // rotate right by 1 means bit (i+1) mod 8
            wire shifted_bit = stage2[(i+1) % 8];
            mux2X1 m1(
                .d0(stage2[i]),
                .d1(shifted_bit),
                .sel(ctrl[0]),
                .y(stage3[i])
            );
        end
    endgenerate

    assign out = stage3;

endmodule