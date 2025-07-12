module mux2X1 (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);
    assign out = sel ? b : a;
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    wire [7:0] stage1;
    wire [7:0] stage2;

    genvar i;

    // Stage 1: shift by 4 if ctrl[2] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_mux
            mux2X1 mux_inst (
                .a(in[i]),
                .b(in[(i + 4) % 8]),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 if ctrl[1] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_mux
            mux2X1 mux_inst (
                .a(stage1[i]),
                .b(stage1[(i + 2) % 8]),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 if ctrl[0] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_mux
            mux2X1 mux_inst (
                .a(stage2[i]),
                .b(stage2[(i + 1) % 8]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule