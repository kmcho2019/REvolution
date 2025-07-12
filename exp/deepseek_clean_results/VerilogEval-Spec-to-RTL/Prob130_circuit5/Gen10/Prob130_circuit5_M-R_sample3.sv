module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

assign q = (c > 4'b0011) ? 4'b1111 :  // Default case
           (c == 4'b0000) ? b :       // Case 0
           (c == 4'b0001) ? e :       // Case 1
           (c == 4'b0010) ? a :       // Case 2
           d;                         // Case 3 (c == 4'b0011)

endmodule