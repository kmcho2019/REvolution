module mux2X1 (
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    wire [7:0] stage1; // after shift by 4 controlled by ctrl[2]
    wire [7:0] stage2; // after shift by 2 controlled by ctrl[1]

    // Stage 1: shift by 4 if ctrl[2] is high (rotate right by 4)
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : stage1_muxes
            mux2X1 mux4 (
                .in0(in[i]),
                .in1(in[(i+4)%8]),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 if ctrl[1] is high (rotate right by 2)
    generate
        for (i=0; i<8; i=i+1) begin : stage2_muxes
            mux2X1 mux2 (
                .in0(stage1[i]),
                .in1(stage1[(i+2)%8]),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 if ctrl[0] is high (rotate right by 1)
    generate
        for (i=0; i<8; i=i+1) begin : stage3_muxes
            mux2X1 mux1 (
                .in0(stage2[i]),
                .in1(stage2[(i+1)%8]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule