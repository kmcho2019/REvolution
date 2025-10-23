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
    wire [7:0] shifted_by_4;
    wire [7:0] stage1_out;
    wire [7:0] shifted_by_2;
    wire [7:0] stage2_out;
    wire [7:0] shifted_by_1;

    // Rotate right by 4 bits
    assign shifted_by_4 = {in[3:0], in[7:4]};
    // Use mux2X1 per bit for stage 1 selection
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : stage1_mux
            mux2X1 mux (
                .in0(in[i]),
                .in1(shifted_by_4[i]),
                .sel(ctrl[2]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Rotate right by 2 bits
    assign shifted_by_2 = {stage1_out[1:0], stage1_out[7:2]};
    generate
        for (i=0; i<8; i=i+1) begin : stage2_mux
            mux2X1 mux (
                .in0(stage1_out[i]),
                .in1(shifted_by_2[i]),
                .sel(ctrl[1]),
                .out(stage2_out[i])
            );
        end
    endgenerate

    // Rotate right by 1 bit
    assign shifted_by_1 = {stage2_out[0], stage2_out[7:1]};
    generate
        for (i=0; i<8; i=i+1) begin : stage3_mux
            mux2X1 mux (
                .in0(stage2_out[i]),
                .in1(shifted_by_1[i]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule