module TopModule(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input [15:0] d,
    input [15:0] e,
    input [15:0] f,
    input [15:0] g,
    input [15:0] h,
    input [15:0] i,
    input [3:0] sel,
    output [15:0] out
);

wire sel_valid = (sel >= 4'd0) && (sel <= 4'd8);
wire [15:0] input_a = (sel == 4'd0) ? a : 16'h0;
wire [15:0] input_b = (sel == 4'd1) ? b : 16'h0;
wire [15:0] input_c = (sel == 4'd2) ? c : 16'h0;
wire [15:0] input_d = (sel == 4'd3) ? d : 16'h0;
wire [15:0] input_e = (sel == 4'd4) ? e : 16'h0;
wire [15:0] input_f = (sel == 4'd5) ? f : 16'h0;
wire [15:0] input_g = (sel == 4'd6) ? g : 16'h0;
wire [15:0] input_h = (sel == 4'd7) ? h : 16'h0;
wire [15:0] input_i = (sel == 4'd8) ? i : 16'h0;

assign out = sel_valid ? (input_a | input_b | input_c | input_d | input_e | input_f | input_g | input_h | input_i) : 16'hffff;

endmodule