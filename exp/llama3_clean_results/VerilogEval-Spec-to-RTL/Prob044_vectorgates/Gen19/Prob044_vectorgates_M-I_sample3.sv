// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    assign out_or_bitwise = a | b; // Directly compute bitwise-OR
    assign out_or_logical = (|a) || (|b); // Simplified logical-OR, no change
    assign out_not[5:3] = ~b; // Invert b and assign directly to out_not
    assign out_not[2:0] = ~a; // Invert a and assign directly to out_not
endmodule