module BitwiseOR #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);
    // Bitwise OR operation
    assign out = a | b;
endmodule

module LogicalOR #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output out
);
    // More efficient logical OR using single reduction
    assign out = |(a | b);
endmodule

module VectorNOT #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [2*WIDTH-1:0] out
);
    // Concatenated NOT operations with b in upper bits
    assign out = {~b, ~a};
endmodule

module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Instantiate modules with compact syntax
    BitwiseOR #(3) bit_or (.a(a), .b(b), .out(out_or_bitwise));
    LogicalOR #(3) log_or (.a(a), .b(b), .out(out_or_logical));
    VectorNOT #(3) vec_not (.a(a), .b(b), .out(out_not));
endmodule