module BitwiseOR (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out
);
    assign out = a | b;
endmodule

module LogicalOR (
    input [2:0] a,
    input [2:0] b,
    output out
);
    assign out = |a || |b;
endmodule

module VectorNOT (
    input [2:0] a,
    input [2:0] b,
    output [5:0] out
);
    assign out = {~b, ~a};
endmodule

module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    BitwiseOR bit_or (.a(a), .b(b), .out(out_or_bitwise));
    LogicalOR log_or (.a(a), .b(b), .out(out_or_logical));
    VectorNOT vec_not (.a(a), .b(b), .out(out_not));
endmodule