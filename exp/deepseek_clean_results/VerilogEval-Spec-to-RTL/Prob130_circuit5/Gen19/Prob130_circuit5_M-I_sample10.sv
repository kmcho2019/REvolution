module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Direct 4:1 mux implementation with fallback to 'f'
assign q = (|c[3:2]) ? 4'b1111 :  // Output 'f' if c[3:2] not zero
           (c[1:0] == 2'b00) ? b :
           (c[1:0] == 2'b01) ? e :
           (c[1:0] == 2'b10) ? a :
           d;  // default case when c[1:0] == 2'b11

endmodule