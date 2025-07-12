module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    assign out = (sel? 8'b11111111 : 8'b0) & b | (~sel & 8'b11111111) & a;

endmodule