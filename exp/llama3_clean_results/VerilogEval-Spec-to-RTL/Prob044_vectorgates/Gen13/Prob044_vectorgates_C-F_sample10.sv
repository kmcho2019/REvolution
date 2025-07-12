// Module for bitwise-OR operation and inversion
module BitwiseORAndInvert(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] or_out,
    output [5:0] inv_out
);
    assign or_out = a | b;
    assign inv_out[5:3] = ~b;
    assign inv_out[2:0] = ~a;
endmodule

// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    wire [5:0] inv_out;

    BitwiseORAndInvert u_bitwise_or_and_invert(
       .a(a),
       .b(b),
       .or_out(out_or_bitwise),
       .inv_out(inv_out)
    );

    assign out_or_logical = |a || |b;
    assign out_not = inv_out;
endmodule