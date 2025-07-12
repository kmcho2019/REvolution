// Solution 1: Using ternary operator (recommended)
module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    assign out = sel ? b : a;

endmodule

// Solution 2: Using explicit bitwise operations (matches original style)
module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    assign out = (~{8{sel}} & a) | ({8{sel}} & b);

endmodule