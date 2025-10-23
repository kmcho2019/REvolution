module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    wire [2:0] inv_a, inv_b;

    // Perform bitwise-OR operation
    assign out_or_bitwise = a | b;

    // Perform logical-OR operation by checking if either vector has any '1' bits
    assign out_or_logical = (|a) || (|b);

    // Perform inversion of input vectors
    assign inv_a = ~a;
    assign inv_b = ~b;

    // Assign inversion of b to upper half of out_not and inversion of a to lower half
    assign out_not[5:3] = inv_b;
    assign out_not[2:0] = inv_a;
endmodule