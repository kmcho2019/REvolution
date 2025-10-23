module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Direct implementation using conditional operators
assign q = (c == 0) ? b :
           (c == 1) ? e :
           (c == 2) ? a :
           (c == 3) ? d :
           4'b1111;  // Default case for c > 3

endmodule