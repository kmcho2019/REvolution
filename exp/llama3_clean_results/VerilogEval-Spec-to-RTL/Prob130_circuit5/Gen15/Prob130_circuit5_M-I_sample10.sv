module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

// Override output if c[3:2] != 2'b00
assign q = (c[3:2] != 2'b00) ? 4'b1111 :
           (c[1:0] == 2'b00) ? b :
           (c[1:0] == 2'b01) ? e :
           (c[1:0] == 2'b10) ? a :
           (c[1:0] == 2'b11) ? d : 4'b0000;

endmodule