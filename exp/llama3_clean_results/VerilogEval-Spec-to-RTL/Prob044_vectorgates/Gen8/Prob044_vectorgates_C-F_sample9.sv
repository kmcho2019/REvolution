// Module for inversion operation
module Inverter(
    input  [2:0] in,
    output [2:0] out
);
    assign out = ~in;
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

    assign out_or_bitwise = a | b;
    assign out_or_logical = (a != 3'b000) || (b != 3'b000);

    Inverter u_inv_a(
        .in(a),
        .out(inv_a)
    );

    Inverter u_inv_b(
        .in(b),
        .out(inv_b)
    );

    assign out_not[5:3] = inv_b;
    assign out_not[2:0] = inv_a;
endmodule