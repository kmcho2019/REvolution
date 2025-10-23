// Define the TopModule with inputs a, b, sel, and output out
module TopModule(
    // 100-bit input vectors a and b
    input  [99:0] a,
    input  [99:0] b,
    // 1-bit select input sel
    input  sel,
    // 100-bit output vector out
    output [99:0] out
);

// Use a ternary operator to assign out based on sel, choosing a when sel is 0 and b when sel is 1
assign out = sel ? b : a;

endmodule