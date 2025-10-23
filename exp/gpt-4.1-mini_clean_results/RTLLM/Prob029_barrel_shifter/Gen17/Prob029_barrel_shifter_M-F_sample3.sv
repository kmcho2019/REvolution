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
    // Stage 1: shift right by 4 if ctrl[2]
    wire [7:0] stage1_shifted;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            // Shift right by 4 bits: bit i gets input bit (i+4)%8
            mux2X1 mux_inst (
                .in0(in[i]),
                .in1(in[(i+4)%8]),
                .sel(ctrl[2]),
                .out(stage1_shifted[i])
            );
        end
    endgenerate

    // Stage 2: shift right by 2 if ctrl[1]
    wire [7:0] stage2_shifted;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            // Shift right by 2 bits: bit i gets stage1_shifted bit (i+2)%8
            mux2X1 mux_inst (
                .in0(stage1_shifted[i]),
                .in1(stage1_shifted[(i+2)%8]),
                .sel(ctrl[1]),
                .out(stage2_shifted[i])
            );
        end
    endgenerate

    // Stage 3: shift right by 1 if ctrl[0]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_muxes
            // Shift right by 1 bit: bit i gets stage2_shifted bit (i+1)%8
            mux2X1 mux_inst (
                .in0(stage2_shifted[i]),
                .in1(stage2_shifted[(i+1)%8]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule