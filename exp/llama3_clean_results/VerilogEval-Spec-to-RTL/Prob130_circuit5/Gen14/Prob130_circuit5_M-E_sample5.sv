module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

wire [3:0] sel_a, sel_b, sel_d, sel_e, sel_default;

assign sel_a = (c == 4'b0010) ? 4'b0001 : 4'b0000;
assign sel_b = (c == 4'b0000) ? 4'b0001 : 4'b0000;
assign sel_d = (c == 4'b0011) ? 4'b0001 : 4'b0000;
assign sel_e = (c == 4'b0001) ? 4'b0001 : 4'b0000;
assign sel_default = ~(sel_a | sel_b | sel_d | sel_e);

assign q = (sel_a & a) | (sel_b & b) | (sel_d & d) | (sel_e & e) | (sel_default & 4'b1111);

endmodule