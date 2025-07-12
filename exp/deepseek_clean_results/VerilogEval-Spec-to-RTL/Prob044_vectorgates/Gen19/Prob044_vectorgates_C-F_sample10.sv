// Bitwise OR module with parameterized width
module BitwiseOR #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);
    // Parallel bitwise OR operation
    assign out = a | b;
endmodule

// Optimized Logical OR module with parameterized width
module LogicalOR #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output out
);
    // Efficient single reduction OR operation
    assign out = |(a | b);
endmodule

// Vector NOT module with parameterized width
module VectorNOT #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [2*WIDTH-1:0] out
);
    // Concatenated NOT operations with b in upper bits, a in lower
    assign out = {~b, ~a};
endmodule

// Top module with default 3-bit width
module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Instantiate modules with default width
    BitwiseOR bit_or (.a(a), .b(b), .out(out_or_bitwise));
    LogicalOR log_or (.a(a), .b(b), .out(out_or_logical));
    VectorNOT vec_not (.a(a), .b(b), .out(out_not));
endmodule