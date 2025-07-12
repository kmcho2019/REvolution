// Refactored TopModule with merged functionalities
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    assign out_or_bitwise = a | b; // Bitwise-OR operation
    assign out_or_logical = (a != 3'b000) || (b != 3'b000); // Logical-OR operation
    assign out_not[5:3] = ~b; // Inverse of b
    assign out_not[2:0] = ~a; // Inverse of a
endmodule