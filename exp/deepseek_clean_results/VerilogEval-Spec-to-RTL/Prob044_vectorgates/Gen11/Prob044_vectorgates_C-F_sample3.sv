module BitwiseOR #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);
    // Optimized bitwise OR using NOT-NOR (De Morgan's Law)
    // May be more efficient in some technology libraries
    assign out = ~(~a & ~b);
endmodule

module LogicalOR #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output out
);
    // Most efficient logical OR using single reduction operation
    assign out = |(a | b);
endmodule

module VectorNOT #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [2*WIDTH-1:0] out
);
    // Concatenated NOT operations with b in upper bits, a in lower
    // Clear bit ordering specification
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
    BitwiseOR #(.WIDTH(3)) bit_or (.a(a), .b(b), .out(out_or_bitwise));
    LogicalOR #(.WIDTH(3)) log_or (.a(a), .b(b), .out(out_or_logical));
    VectorNOT #(.WIDTH(3)) vec_not (.a(a), .b(b), .out(out_not));
endmodule