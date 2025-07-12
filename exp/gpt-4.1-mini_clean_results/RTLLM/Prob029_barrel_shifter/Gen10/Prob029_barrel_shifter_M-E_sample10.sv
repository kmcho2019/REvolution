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
    wire [7:0] stage0_out, stage1_out;

    // Stage 0: rotate by 4 bits if ctrl[2] = 1, else pass through
    // For each bit i: select between in[i] and in[(i+4)%8]
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : stage0_muxes
            mux2X1 mux4 (
                .in0(in[i]),
                .in1(in[(i+4)%8]),
                .sel(ctrl[2]),
                .out(stage0_out[i])
            );
        end
    endgenerate

    // Stage 1: rotate by 2 bits if ctrl[1] = 1, else pass through
    // For each bit i: select between stage0_out[i] and stage0_out[(i+2)%8]
    generate
        for (i=0; i<8; i=i+1) begin : stage1_muxes
            mux2X1 mux2 (
                .in0(stage0_out[i]),
                .in1(stage0_out[(i+2)%8]),
                .sel(ctrl[1]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: rotate by 1 bit if ctrl[0] = 1, else pass through
    // For each bit i: select between stage1_out[i] and stage1_out[(i+1)%8]
    generate
        for (i=0; i<8; i=i+1) begin : stage2_muxes
            mux2X1 mux1 (
                .in0(stage1_out[i]),
                .in1(stage1_out[(i+1)%8]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule