module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

assign q = (|c[3:2]) ? 4'hf :  // If c >=4, output 'f'
           (c[1:0] == 2'b00) ? b :  // case 0
           (c[1:0] == 2'b01) ? e :  // case 1
           (c[1:0] == 2'b10) ? a :  // case 2
           (c[1:0] == 2'b11) ? d :  // case 3
           4'hf;  // default (shouldn't occur)

endmodule