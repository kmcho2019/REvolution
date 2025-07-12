module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Simplified invalid case detection (c >=4 when c[2] is 1)
wire invalid_case = c[2];

// 4:1 multiplexer implementation
assign q = invalid_case ? 4'b1111 : 
           (c[1:0] == 2'b00) ? b :
           (c[1:0] == 2'b01) ? e :
           (c[1:0] == 2'b10) ? a :
           d;  // default case when c[1:0] == 2'b11

endmodule