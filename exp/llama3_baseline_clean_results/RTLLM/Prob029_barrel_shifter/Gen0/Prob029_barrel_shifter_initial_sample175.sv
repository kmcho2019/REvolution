module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

// Define the 2-to-1 multiplexer submodule
module mux2X1(
    input  [7:0] a, b,
    input         sel,
    output [7:0] y
);
    assign y = (sel) ? b : a;
endmodule

// Stage 1: Shift by 4 positions based on ctrl[2]
wire [7:0] stage1_in_shifted;
assign stage1_in_shifted = {in[3:0], 4'b0000};

mux2X1 stage1(
    .a(in),
    .b(stage1_in_shifted),
    .sel(ctrl[2]),
    .y(out_stage1)
);

// Stage 2: Shift by 2 positions based on ctrl[1]
wire [7:0] stage2_in_shifted;
assign stage2_in_shifted = {out_stage1[5:0], 2'b00};

mux2X1 stage2(
    .a(out_stage1),
    .b(stage2_in_shifted),
    .sel(ctrl[1]),
    .y(out_stage2)
);

// Stage 3: Shift by 1 position based on ctrl[0]
wire [7:0] stage3_in_shifted;
assign stage3_in_shifted = {out_stage2[6:0], 1'b0};

mux2X1 stage3(
    .a(out_stage2),
    .b(stage3_in_shifted),
    .sel(ctrl[0]),
    .y(out)
);

wire [7:0] out_stage1, out_stage2;

endmodule