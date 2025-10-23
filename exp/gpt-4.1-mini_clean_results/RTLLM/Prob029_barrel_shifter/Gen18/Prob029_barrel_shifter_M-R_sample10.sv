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

    // Stage 1: shift by 4 controlled by ctrl[2]
    wire [7:0] stage1;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift4_stage
            // rotate left by 4: bit i gets in[(i-4) mod 8]
            // compute source bits
            wire in0 = in[i];
            wire in1 = in[(i + 4) % 8]; // rotation left by 4
            mux2X1 mux4 (
                .in0(in0),
                .in1(in1),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 controlled by ctrl[1]
    wire [7:0] stage2;
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift2_stage
            // rotate left by 2: bit i gets stage1[(i-2) mod 8]
            wire in0 = stage1[i];
            wire in1 = stage1[(i + 2) % 8];
            mux2X1 mux2 (
                .in0(in0),
                .in1(in1),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 controlled by ctrl[0]
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift1_stage
            // rotate left by 1: bit i gets stage2[(i-1) mod 8]
            wire in0 = stage2[i];
            wire in1 = stage2[(i + 1) % 8];
            mux2X1 mux1 (
                .in0(in0),
                .in1(in1),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule