// Module to compute bitwise-OR of two 3-bit vectors
module BitwiseOR(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out
);
    assign out = a | b;
endmodule

// Module to compute logical-OR of two 3-bit vectors
module LogicalOR(
    input  [2:0] a,
    input  [2:0] b,
    output       out
);
    assign out = |a || |b;
endmodule

// Module to compute NOT of a 3-bit vector
module NOT(
    input  [2:0] a,
    output [2:0] out
);
    assign out = ~a;
endmodule

// TopModule utilizing the smaller modules
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    wire [2:0] not_a;
    wire [2:0] not_b;

    // Instantiate modules for computations
    BitwiseOR u_bitwise_or(.a(a),.b(b),.out(out_or_bitwise));
    LogicalOR u_logical_or(.a(a),.b(b),.out(out_or_logical));
    NOT u_not_a(.a(a),.out(not_a));
    NOT u_not_b(.a(b),.out(not_b));

    // Combine NOT results as per requirement
    assign out_not[5:3] = not_b;
    assign out_not[2:0] = not_a;
endmodule