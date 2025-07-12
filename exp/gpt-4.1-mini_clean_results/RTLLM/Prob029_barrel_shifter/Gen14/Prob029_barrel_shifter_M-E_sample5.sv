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
    // Stage 0: shift by 4 if ctrl[2] = 1
    wire [7:0] stage0;
    // Stage 1: shift by 2 if ctrl[1] = 1
    wire [7:0] stage1;
    // Stage 2: shift by 1 if ctrl[0] = 1
    wire [7:0] stage2;

    genvar i;

    // Stage 0 muxes for rotate by 4
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage0_muxes
            // Rotate left by 4: new bit i = in[(i - 4) mod 8]
            localparam shifted_idx = (i + 4) % 8;
            mux2X1 u_mux0 (
                .in0(in[i]),
                .in1(in[shifted_idx]),
                .sel(ctrl[2]),
                .out(stage0[i])
            );
        end
    endgenerate

    // Stage 1 muxes for rotate by 2
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            // Rotate left by 2: new bit i = stage0[(i - 2) mod 8]
            localparam shifted_idx = (i + 2) % 8;
            mux2X1 u_mux1 (
                .in0(stage0[i]),
                .in1(stage0[shifted_idx]),
                .sel(ctrl[1]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2 muxes for rotate by 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            // Rotate left by 1: new bit i = stage1[(i - 1) mod 8]
            localparam shifted_idx = (i + 1) % 8;
            mux2X1 u_mux2 (
                .in0(stage1[i]),
                .in1(stage1[shifted_idx]),
                .sel(ctrl[0]),
                .out(stage2[i])
            );
        end
    endgenerate

    assign out = stage2;

endmodule