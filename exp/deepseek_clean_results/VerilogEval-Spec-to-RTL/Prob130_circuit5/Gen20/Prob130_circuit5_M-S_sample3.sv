module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

assign q = (|c[3:2]) ? 4'b1111 :  // Output 'f' if c >= 4
           (c[1:0] == 2'b00) ? b :  // c=0: output b
           (c[1:0] == 2'b01) ? e :  // c=1: output e
           (c[1:0] == 2'b10) ? a :  // c=2: output a
           d;                       // c=3: output d

endmodule