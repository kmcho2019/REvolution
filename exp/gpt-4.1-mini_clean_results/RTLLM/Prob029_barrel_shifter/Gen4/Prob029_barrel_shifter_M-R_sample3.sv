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

    wire [7:0] stage1;  // after shift by 4 controlled by ctrl[2]
    wire [7:0] stage2;  // after shift by 2 controlled by ctrl[1]

    // Stage 1: shift by 4 if ctrl[2] == 1, else pass through
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : stage1_muxes
            // rotate left by 4 bits: bit i comes from bit (i+4)%8
            mux2X1 mux4 (
                .d0(in[i]),
                .d1(in[(i+4)%8]),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 if ctrl[1] == 1, else pass through
    generate
        for (i=0; i<8; i=i+1) begin : stage2_muxes
            // rotate left by 2 bits: bit i comes from bit (i+2)%8
            mux2X1 mux2 (
                .d0(stage1[i]),
                .d1(stage1[(i+2)%8]),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 if ctrl[0] == 1, else pass through
    generate
        for (i=0; i<8; i=i+1) begin : stage3_muxes
            // rotate left by 1 bit: bit i comes from bit (i+1)%8
            mux2X1 mux1 (
                .d0(stage2[i]),
                .d1(stage2[(i+1)%8]),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule