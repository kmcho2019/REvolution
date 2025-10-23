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

    wire [7:0] stage4;
    wire [7:0] stage2;

    genvar i;

    // Stage 1: shift by 4 if ctrl[2] = 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift4_stage
            // Calculate shifted index with wrap-around
            wire shifted_idx = (i + 4) < 8 ? (i + 4) : (i + 4 - 8);
            mux2X1 mux4 (
                .in0(in[i]),
                .in1(in[shifted_idx]),
                .sel(ctrl[2]),
                .out(stage4[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 if ctrl[1] = 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift2_stage
            wire shifted_idx = (i + 2) < 8 ? (i + 2) : (i + 2 - 8);
            mux2X1 mux2 (
                .in0(stage4[i]),
                .in1(stage4[shifted_idx]),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 if ctrl[0] = 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift1_stage
            wire shifted_idx = (i + 1) < 8 ? (i + 1) : (i + 1 - 8);
            mux2X1 mux1 (
                .in0(stage2[i]),
                .in1(stage2[shifted_idx]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule