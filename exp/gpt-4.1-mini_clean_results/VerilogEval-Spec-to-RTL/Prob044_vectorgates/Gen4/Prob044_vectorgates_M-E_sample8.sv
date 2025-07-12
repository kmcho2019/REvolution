module BitwiseOR (
    input  [2:0] in1,
    input  [2:0] in2,
    output [2:0] out_or
);
    assign out_or = in1 | in2;
endmodule

module BitwiseNOT (
    input  [2:0] in,
    output [2:0] out_not
);
    assign out_not = ~in;
endmodule

module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    wire [2:0] not_a;
    wire [2:0] not_b;

    BitwiseOR u_or (
        .in1(a),
        .in2(b),
        .out_or(out_or_bitwise)
    );

    BitwiseNOT u_not_a (
        .in(a),
        .out_not(not_a)
    );

    BitwiseNOT u_not_b (
        .in(b),
        .out_not(not_b)
    );

    assign out_or_logical = |out_or_bitwise;
    assign out_not = {not_b, not_a};

endmodule