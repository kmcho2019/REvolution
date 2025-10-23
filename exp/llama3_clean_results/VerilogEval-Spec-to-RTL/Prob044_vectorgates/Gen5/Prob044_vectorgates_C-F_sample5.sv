// TopModule integrating all operations
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Bitwise-OR operation
    assign out_or_bitwise = a | b;

    // Logical-OR operation
    assign out_or_logical = (a != 3'b000) || (b != 3'b000);

    // Inverse operations and assignment to out_not
    assign out_not[5:3] = ~b; // Inverse of b
    assign out_not[2:0] = ~a; // Inverse of a
endmodule