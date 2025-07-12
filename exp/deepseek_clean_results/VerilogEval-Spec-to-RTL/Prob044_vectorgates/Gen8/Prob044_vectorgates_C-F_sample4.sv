module VectorOperations #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] bitwise_or,
    output logical_or,
    output [2*WIDTH-1:0] not_vectors
);
    // Direct bitwise OR for best timing
    assign bitwise_or = a | b;
    
    // Single reduction OR for lowest power
    assign logical_or = |(a | b);
    
    // Efficient NOT with concatenation
    assign not_vectors = {~b, ~a};
endmodule

module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    VectorOperations #(.WIDTH(3)) vec_ops (
        .a(a),
        .b(b),
        .bitwise_or(out_or_bitwise),
        .logical_or(out_or_logical),
        .not_vectors(out_not)
    );
endmodule