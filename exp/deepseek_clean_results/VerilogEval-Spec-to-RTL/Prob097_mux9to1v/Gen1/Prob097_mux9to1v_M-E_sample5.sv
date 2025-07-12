module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

wire [15:0] sel_a = {16{sel == 4'd0}};
wire [15:0] sel_b = {16{sel == 4'd1}};
wire [15:0] sel_c = {16{sel == 4'd2}};
wire [15:0] sel_d = {16{sel == 4'd3}};
wire [15:0] sel_e = {16{sel == 4'd4}};
wire [15:0] sel_f = {16{sel == 4'd5}};
wire [15:0] sel_g = {16{sel == 4'd6}};
wire [15:0] sel_h = {16{sel == 4'd7}};
wire [15:0] sel_i = {16{sel == 4'd8}};
wire [15:0] sel_default = {16{sel > 4'd8}};

assign out = (a & sel_a) | (b & sel_b) | (c & sel_c) | 
             (d & sel_d) | (e & sel_e) | (f & sel_f) |
             (g & sel_g) | (h & sel_h) | (i & sel_i) |
             (16'hFFFF & sel_default);

endmodule