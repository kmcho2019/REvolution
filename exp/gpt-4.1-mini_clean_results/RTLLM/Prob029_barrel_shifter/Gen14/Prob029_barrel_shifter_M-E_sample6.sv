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
    wire [7:0] stage0_out;
    wire [7:0] stage1_out;

    // Stage 0: rotate by 4 bits if ctrl[2] == 1
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage0_muxes
            // Calculate shifted index with wrap-around
            localparam shifted_idx = (i + 4) % 8;
            mux2X1 mux_inst (
                .in0(in[i]),
                .in1(in[shifted_idx]),
                .sel(ctrl[2]),
                .out(stage0_out[i])
            );
        end
    endgenerate

    // Stage 1: rotate by 2 bits if ctrl[1] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            localparam shifted_idx = (i + 2) % 8;
            mux2X1 mux_inst (
                .in0(stage0_out[i]),
                .in1(stage0_out[shifted_idx]),
                .sel(ctrl[1]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: rotate by 1 bit if ctrl[0] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            localparam shifted_idx = (i + 1) % 8;
            mux2X1 mux_inst (
                .in0(stage1_out[i]),
                .in1(stage1_out[shifted_idx]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule