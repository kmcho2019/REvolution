// Define the mux2X1 submodule
module mux2X1(
    input   wire    sel,
    input   wire    in0,
    input   wire    in1,
    output  wire    out
);

    assign out = (sel) ? in1 : in0;

endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input   wire    [7:0] in,
    input   wire    [2:0] ctrl,
    output  wire    [7:0] out
);

    // Stage 1: Shift by 4 positions
    wire [7:0] stage1_out;
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            mux2X1 mux_stage1(
                .sel(ctrl[2]),
                .in0(in[i]),
                .in1(i < 4 ? 1'b0 : in[i - 4]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: Shift by 2 positions
    wire [7:0] stage2_out;
    generate
        for (i = 0; i < 8; i++) begin
            mux2X1 mux_stage2(
                .sel(ctrl[1]),
                .in0(stage1_out[i]),
                .in1(i < 2 ? 1'b0 : stage1_out[i - 2]),
                .out(stage2_out[i])
            );
        end
    endgenerate

    // Stage 3: Shift by 1 position
    generate
        for (i = 0; i < 8; i++) begin
            mux2X1 mux_stage3(
                .sel(ctrl[0]),
                .in0(stage2_out[i]),
                .in1(i == 0 ? 1'b0 : stage2_out[i - 1]),
                .out(out[i])
            );
        end
    endgenerate

endmodule