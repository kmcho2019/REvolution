module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output wire [3:0] q
);

assign q = (c[3:2]!= 2'b00)? 4'd15 :
           (c[1:0] == 2'b00)? (c == 4'd0)? b : 4'd15 :
           (c[1:0] == 2'b01)? (c == 4'd1)? e : 4'd15 :
           (c[1:0] == 2'b10)? (c == 4'd2)? a : 4'd15 :
           (c[1:0] == 2'b11)? (c == 4'd3)? d : 4'd15 :
           4'd15;

endmodule