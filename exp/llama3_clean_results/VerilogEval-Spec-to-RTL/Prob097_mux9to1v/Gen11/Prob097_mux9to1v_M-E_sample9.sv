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

wire [15:0] sel_a = (sel == 4'd0)? a : 16'd0;
wire [15:0] sel_b = (sel == 4'd1)? b : 16'd0;
wire [15:0] sel_c = (sel == 4'd2)? c : 16'd0;
wire [15:0] sel_d = (sel == 4'd3)? d : 16'd0;
wire [15:0] sel_e = (sel == 4'd4)? e : 16'd0;
wire [15:0] sel_f = (sel == 4'd5)? f : 16'd0;
wire [15:0] sel_g = (sel == 4'd6)? g : 16'd0;
wire [15:0] sel_h = (sel == 4'd7)? h : 16'd0;
wire [15:0] sel_i = (sel == 4'd8)? i : 16'd0;

wire [15:0] sel_all = (sel > 4'd8)? 16'd0 : 16'd0;

assign out = sel_a | sel_b | sel_c | sel_d | sel_e | sel_f | sel_g | sel_h | sel_i | (sel > 4'd8? 16'hFFFF : 16'd0);

endmodule