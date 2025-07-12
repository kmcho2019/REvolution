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

wire [8:0] dec_out;
decoder dec(sel, dec_out);

tri buf_a(out, a, dec_out[0]);
tri buf_b(out, b, dec_out[1]);
tri buf_c(out, c, dec_out[2]);
tri buf_d(out, d, dec_out[3]);
tri buf_e(out, e, dec_out[4]);
tri buf_f(out, f, dec_out[5]);
tri buf_g(out, g, dec_out[6]);
tri buf_h(out, h, dec_out[7]);
tri buf_i(out, i, dec_out[8]);
tri buf_def(out, 16'hFFFF, ~(dec_out[0] | dec_out[1] | dec_out[2] | dec_out[3] | dec_out[4] | dec_out[5] | dec_out[6] | dec_out[7] | dec_out[8]));

endmodule

module decoder(input [3:0] in, output [8:0] out);
    assign out[0] = (in == 4'd0);
    assign out[1] = (in == 4'd1);
    assign out[2] = (in == 4'd2);
    assign out[3] = (in == 4'd3);
    assign out[4] = (in == 4'd4);
    assign out[5] = (in == 4'd5);
    assign out[6] = (in == 4'd6);
    assign out[7] = (in == 4'd7);
    assign out[8] = (in == 4'd8);
endmodule

module tri(output [15:0] out, input [15:0] in, input enable);
    assign out = enable ? in : 16'bz;
endmodule