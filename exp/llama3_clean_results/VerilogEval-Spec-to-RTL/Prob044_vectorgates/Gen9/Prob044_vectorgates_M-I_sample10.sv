// Top-level module with optimizations
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    assign out_or_bitwise = a | b; // Inlined bitwise-OR operation
    assign out_or_logical = (a != 3'b000) || (b != 3'b000); // Maintained direct logical-OR computation
    assign out_not[5:3] = ~b; // Direct assignment of inverted b
    assign out_not[2:0] = ~a; // Direct assignment of inverted a
endmodule