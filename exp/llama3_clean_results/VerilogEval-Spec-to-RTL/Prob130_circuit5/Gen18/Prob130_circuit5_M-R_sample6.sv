module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

wire override = (c[3:2] != 2'b00);

assign q = override ? 4'b1111 :
           (c[1:0] == 2'b00 && c == 4'd0) ? b :
           (c[1:0] == 2'b01 && c == 4'd1) ? e :
           (c[1:0] == 2'b10 && c == 4'd2) ? a :
           (c[1:0] == 2'b11 && c == 4'd3) ? d : 4'b1111;

endmodule