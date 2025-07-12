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
    assign out = |a || |b;
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

    LogicalOR u_logical_or(
        .a(a),
        .b(b),
        .out(out_or_logical)
    );

    assign inv_a = ~a;
    assign inv_b = ~b;

    assign out_not[5:3] = inv_b;
    assign out_not[2:0] = inv_a;
endmodule