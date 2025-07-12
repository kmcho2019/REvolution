// Module for bitwise-OR operation
module BitwiseOR(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out
);
    assign out = a | b;
endmodule

// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    wire [2:0] inv_a, inv_b;

    BitwiseOR u_bitwise_or(
       .a(a),
       .b(b),
       .out(out_or_bitwise)
    );

    assign inv_a = ~a; // Direct inversion within TopModule
    assign inv_b = ~b; // Direct inversion within TopModule
    assign out_not[5:3] = inv_b; // Assign inversion of b to upper half of out_not
    assign out_not[2:0] = inv_a; // Assign inversion of a to lower half of out_not
    assign out_or_logical = (|a) || (|b); // Simplified condition for any '1' bit in either vector
endmodule