module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Improved implementation using priority encoding
assign q = (c > 4'd3) ? 4'b1111 :  // Default case first for priority
           (c == 4'd0) ? b :
           (c == 4'd1) ? e :
           (c == 4'd2) ? a :
           d;  // c == 4'd3

endmodule