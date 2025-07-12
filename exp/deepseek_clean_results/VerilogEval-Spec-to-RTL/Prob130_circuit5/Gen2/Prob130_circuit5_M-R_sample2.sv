module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

assign q = (c > 4'b0011) ? 4'b1111 :  // Default case first for priority
           (c == 4'b0000) ? b :
           (c == 4'b0001) ? e :
           (c == 4'b0010) ? a :
           d;  // Last case is c == 3

endmodule