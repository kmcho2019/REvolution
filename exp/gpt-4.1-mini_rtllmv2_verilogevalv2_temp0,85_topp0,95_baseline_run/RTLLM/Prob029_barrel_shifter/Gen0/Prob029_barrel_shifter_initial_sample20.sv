module mux2X1(
    input wire in0,
    input wire in1,
    input wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module barrel_shifter(
    input wire [7:0] in,
    input wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1; // after 4-bit shift
    wire [7:0] stage2; // after 2-bit shift

    genvar i;

    // Stage 1: shift by 4 if ctrl[2] is high
    generate
        for (i=0; i<8; i=i+1) begin : shift4
            // rotate by 4: bit i comes from in[(i+4)%8]
            mux2X1 mux4 (
                .in0(in[i]),
                .in1(in[(i+4)%8]),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 if ctrl[1] is high
    generate
        for (i=0; i<8; i=i+1) begin : shift2
            // rotate by 2: bit i comes from stage1[(i+2)%8]
            mux2X1 mux2 (
                .in0(stage1[i]),
                .in1(stage1[(i+2)%8]),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 if ctrl[0] is high
    generate
        for (i=0; i<8; i=i+1) begin : shift1
            // rotate by 1: bit i comes from stage2[(i+1)%8]
            mux2X1 mux1 (
                .in0(stage2[i]),
                .in1(stage2[(i+1)%8]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule