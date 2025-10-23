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

    // Stage 1: shift by 4 positions if ctrl[2]
    wire [7:0] stage1;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_loop
            // Left rotate by 4: output bit i gets input bit (i - 4) mod 8
            mux2X1 mux_stage1 (
                .in0(in[i]),
                .in1(in[(i + 8 - 4) % 8]),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 positions if ctrl[1]
    wire [7:0] stage2;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_loop
            // Left rotate by 2: output bit i gets stage1 bit (i - 2) mod 8
            mux2X1 mux_stage2 (
                .in0(stage1[i]),
                .in1(stage1[(i + 8 - 2) % 8]),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 position if ctrl[0]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_loop
            // Left rotate by 1: output bit i gets stage2 bit (i - 1) mod 8
            mux2X1 mux_stage3 (
                .in0(stage2[i]),
                .in1(stage2[(i + 8 - 1) % 8]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule