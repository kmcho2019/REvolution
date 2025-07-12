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

    wire [7:0] stage4;
    wire [7:0] stage2;

    genvar i;

    // Stage 1: shift by 4 if ctrl[2] = 1
    generate
        for (i=0; i<8; i=i+1) begin : shift4
            // left rotate by 4: new bit i comes from bit (i+4)%8 of input
            mux2X1 mux4 (
                .d0(in[i]),
                .d1(in[(i+4)%8]),
                .sel(ctrl[2]),
                .y(stage4[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 if ctrl[1] = 1
    generate
        for (i=0; i<8; i=i+1) begin : shift2
            // left rotate by 2: new bit i comes from bit (i+2)%8 of stage4
            mux2X1 mux2 (
                .d0(stage4[i]),
                .d1(stage4[(i+2)%8]),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 if ctrl[0] = 1
    generate
        for (i=0; i<8; i=i+1) begin : shift1
            // left rotate by 1: new bit i comes from bit (i+1)%8 of stage2
            mux2X1 mux1 (
                .d0(stage2[i]),
                .d1(stage2[(i+1)%8]),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule