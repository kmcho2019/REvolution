module BitwiseOR #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);
    // Bitwise OR operation - parallel bit operations
    assign out = a | b;
endmodule

module LogicalOR #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output out
);
    // Efficient logical OR using single reduction operation
    assign out = |(a | b);
endmodule

module VectorNOT #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [2*WIDTH-1:0] out
);
    // Concatenated NOT operations with b in upper bits [5:3], a in [2:0]
    assign out = {~b, ~a};
endmodule

module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Instantiate optimized modules with default width
    BitwiseOR bit_or (.a(a), .b(b), .out(out_or_bitwise));
    LogicalOR log_or (.a(a), .b(b), .out(out_or_logical));
    VectorNOT vec_not (.a(a), .b(b), .out(out_not));
endmodule