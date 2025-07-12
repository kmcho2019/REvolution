module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Use case statement for direct selection
assign q = (c < 4) ? 
           (c[1:0] == 2'b00) ? b :
           (c[1:0] == 2'b01) ? e :
           (c[1:0] == 2'b10) ? a :
           d :  // c[1:0] == 2'b11
           4'b1111;  // default case when c >= 4

endmodule