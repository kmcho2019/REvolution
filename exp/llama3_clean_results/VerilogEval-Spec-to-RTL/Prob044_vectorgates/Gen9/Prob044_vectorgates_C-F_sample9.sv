// Module for bitwise-OR operation and inversion
module BitwiseORAndInvert(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] or_out,
    output [2:0] inv_a,
    output [2:0] inv_b
);
    assign or_out = a | b;
    assign inv_a = ~a;
    assign inv_b = ~b;
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

    BitwiseORAndInvert u_bitwise_or_and_invert(
        .a(a),
        .b(b),
        .or_out(out_or_bitwise),
        .inv_a(inv_a),
        .inv_b(inv_b)
    );

    assign out_or_logical = |a || |b;
    assign out_not[5:3] = inv_b;
    assign out_not[2:0] = inv_a;
endmodule