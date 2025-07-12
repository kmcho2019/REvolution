// Top-level module with integrated operations
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Perform bitwise-OR operation
    assign out_or_bitwise = a | b;

    // Perform logical-OR operation using reduction-OR
    assign out_or_logical = |a || |b;

    // Perform inversion operation and assign to output bits
    assign out_not[5:3] = ~b;
    assign out_not[2:0] = ~a;
endmodule