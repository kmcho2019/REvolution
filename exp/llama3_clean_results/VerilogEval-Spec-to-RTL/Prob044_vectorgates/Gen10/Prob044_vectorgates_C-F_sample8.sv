// Module for bitwise-OR operation
module BitwiseOR(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out
);
    assign out = a | b;
endmodule

// Module for logical-OR operation
module LogicalOR(
    input  [2:0] a,
    input  [2:0] b,
    output       out
);
    assign out = (|a) || (|b); // Simplified condition for any '1' bit in either vector
endmodule

// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    BitwiseOR u_bitwise_or(
        .a(a),
        .b(b),
        .out(out_or_bitwise)
    );

    LogicalOR u_logical_or(
        .a(a),
        .b(b),
        .out(out_or_logical)
    );

    assign out_not[5:3] = ~b; // Direct inversion within TopModule
    assign out_not[2:0] = ~a; // Direct inversion within TopModule
endmodule