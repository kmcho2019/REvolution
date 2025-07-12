// Sub-module for bitwise-OR operation
module BitwiseOR(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or
);
    assign out_or = a | b;
endmodule

// Sub-module for logical-OR operation
module LogicalOR(
    input  [2:0] a,
    input  [2:0] b,
    output       out_or
);
    assign out_or = (a != 3'b000) || (b != 3'b000);
endmodule

// Sub-module for inverse operation
module Inverse(
    input  [2:0] in_vec,
    output [2:0] out_inv
);
    assign out_inv = ~in_vec;
endmodule

// TopModule utilizing the sub-modules
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    wire [2:0] inv_a, inv_b;

    BitwiseOR u_bitwise_or(.a(a), .b(b), .out_or(out_or_bitwise));
    LogicalOR u_logical_or(.a(a), .b(b), .out_or(out_or_logical));
    Inverse u_inv_a(.in_vec(a), .out_inv(inv_a));
    Inverse u_inv_b(.in_vec(b), .out_inv(inv_b));

    assign out_not[5:3] = inv_b;
    assign out_not[2:0] = inv_a;
endmodule