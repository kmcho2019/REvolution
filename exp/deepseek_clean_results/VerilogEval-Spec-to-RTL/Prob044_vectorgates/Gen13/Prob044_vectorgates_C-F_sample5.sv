module BitwiseOR #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);
    assign out = a | b;
endmodule

module LogicalOR #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output out
);
    assign out = |(a | b);
endmodule

module VectorNOT #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [2*WIDTH-1:0] out
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
    BitwiseOR #(.WIDTH(3)) bit_or (
        .a(a),
        .b(b),
        .out(out_or_bitwise)
    );
    
    LogicalOR #(.WIDTH(3)) log_or (
        .a(a),
        .b(b),
        .out(out_or_logical)
    );
    
    VectorNOT #(.WIDTH(3)) vec_not (
        .a(a),
        .b(b),
        .out(out_not)
    );
endmodule