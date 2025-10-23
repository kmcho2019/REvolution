module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

wire [3:0] sel_b = (c[1:0] == 2'b00)? b : 4'b0000;
wire [3:0] sel_e = (c[1:0] == 2'b01)? e : 4'b0000;
wire [3:0] sel_a = (c[1:0] == 2'b10)? a : 4'b0000;
wire [3:0] sel_d = (c[1:0] == 2'b11)? d : 4'b0000;

assign q = (c[3:2]!= 2'b00)? 4'b1111 : (sel_b | sel_e | sel_a | sel_d);

endmodule