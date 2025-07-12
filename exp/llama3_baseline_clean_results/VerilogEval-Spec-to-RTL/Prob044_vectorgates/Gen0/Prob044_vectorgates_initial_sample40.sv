module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output        out_or_logical,
    output [5:0] out_not
);

assign out_or_bitwise = a | b; // bitwise-OR operation
assign out_or_logical = (a != 3'b0) || (b != 3'b0); // logical-OR operation
assign out_not[5:3] = ~b; // inverse of b in upper half of out_not
assign out_not[2:0] = ~a; // inverse of a in lower half of out_not

endmodule