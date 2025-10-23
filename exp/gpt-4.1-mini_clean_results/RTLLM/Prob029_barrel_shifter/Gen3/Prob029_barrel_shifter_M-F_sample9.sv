`ifndef MUX2X1_V
`define MUX2X1_V

// 2-to-1 multiplexer module
module mux2X1 (
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

`endif // MUX2X1_V


// 8-bit barrel shifter module using mux2X1
module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Stage 1 wires (shift by 4)
    wire [7:0] stage1;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_mux
            // Rotate left by 4 bits: (i + 4) mod 8
            wire shifted_bit = in[(i + 4) % 8];
            mux2X1 mux_inst (
                .in0(in[i]),
                .in1(shifted_bit),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2 wires (shift by 2)
    wire [7:0] stage2;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_mux
            // Rotate left by 2 bits from stage1 output
            wire shifted_bit = stage1[(i + 2) % 8];
            mux2X1 mux_inst (
                .in0(stage1[i]),
                .in1(shifted_bit),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3 wires (shift by 1)
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_mux
            // Rotate left by 1 bit from stage2 output
            wire shifted_bit = stage2[(i + 1) % 8];
            mux2X1 mux_inst (
                .in0(stage2[i]),
                .in1(shifted_bit),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule