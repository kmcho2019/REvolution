// Module for bitwise-OR operation
module BitwiseOR(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or
);
    assign out_or = a | b;
endmodule

// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    wire [2:0] out_or;

    BitwiseOR u_bitwise_or(
       .a(a),
       .b(b),
       .out_or(out_or)
    );

    assign out_or_bitwise = out_or;
    assign out_or_logical = (|a) || (|b); // Simplified condition for logical-OR
    assign out_not[5:3] = ~b; // Direct inversion of b
    assign out_not[2:0] = ~a; // Direct inversion of a
endmodule