module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0] sel,
    output [15:0] out
);

wire [15:0] mask_a = (sel == 4'd0) ? 16'hFFFF : 16'h0000;
wire [15:0] mask_b = (sel == 4'd1) ? 16'hFFFF : 16'h0000;
wire [15:0] mask_c = (sel == 4'd2) ? 16'hFFFF : 16'h0000;
wire [15:0] mask_d = (sel == 4'd3) ? 16'hFFFF : 16'h0000;
wire [15:0] mask_e = (sel == 4'd4) ? 16'hFFFF : 16'h0000;
wire [15:0] mask_f = (sel == 4'd5) ? 16'hFFFF : 16'h0000;
wire [15:0] mask_g = (sel == 4'd6) ? 16'hFFFF : 16'h0000;
wire [15:0] mask_h = (sel == 4'd7) ? 16'hFFFF : 16'h0000;
wire [15:0] mask_i = (sel == 4'd8) ? 16'hFFFF : 16'h0000;

wire [15:0] temp_out = (a & mask_a) | (b & mask_b) | (c & mask_c) | (d & mask_d) | (e & mask_e) | (f & mask_f) | (g & mask_g) | (h & mask_h) | (i & mask_i);

assign out = (sel < 4'd9) ? temp_out : 16'hFFFF;

endmodule