module BitwiseOR #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);
    // Direct bitwise OR implementation for better performance and area
    assign out = a | b;
endmodule

module LogicalOR #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output out
);
    // Efficient logical OR using reduction OR
    // More power efficient than separate OR trees
    assign out = |a || |b;
endmodule

module VectorNOT #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [2*WIDTH-1:0] out
);
    // Shared NOT computation with b in upper bits [5:3], a in lower bits [2:0]
    assign out = {~b, ~a};
endmodule

module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Instantiate modules with parameterization and compact syntax
    BitwiseOR #(3) bit_or (.a(a), .b(b), .out(out_or_bitwise));
    LogicalOR #(3) log_or (.a(a), .b(b), .out(out_or_logical));
    VectorNOT #(3) vec_not (.a(a), .b(b), .out(out_not));
endmodule