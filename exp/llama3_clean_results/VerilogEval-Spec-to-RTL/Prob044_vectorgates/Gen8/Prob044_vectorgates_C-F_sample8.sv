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

    assign out_or_logical = (a != 3'b000) || (b != 3'b000);
    assign inv_a = ~a;
    assign inv_b = ~b;
    assign out_not[5:3] = inv_b;
    assign out_not[2:0] = inv_a;
endmodule