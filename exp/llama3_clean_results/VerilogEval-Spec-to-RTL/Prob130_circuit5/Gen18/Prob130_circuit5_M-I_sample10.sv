module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

// Assign the output based on the value of c
assign q = (c < 4)? 
           (c == 2'b00)? b :
           (c == 2'b01)? e :
           (c == 2'b10)? a :
           (c == 2'b11)? d :
           4'b0000 :
           4'b1111;

endmodule