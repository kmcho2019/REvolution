module VectorOps #(
    parameter WIDTH = 3
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [WIDTH-1:0] out_or_bitwise,
    output wire             out_or_logical,
    output wire [(2*WIDTH)-1:0] out_not
);
    // Compute bitwise OR once
    wire [WIDTH-1:0] or_vec;
    assign or_vec = a | b;
    assign out_or_bitwise = or_vec;

    // Logical OR reduction of or_vec
    assign out_or_logical = |or_vec;

    // Concatenate NOT of b (upper half) and NOT of a (lower half)
    assign out_not = {~b, ~a};

endmodule

module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    VectorOps #(.WIDTH(3)) vector_ops_inst (
        .a(a),
        .b(b),
        .out_or_bitwise(out_or_bitwise),
        .out_or_logical(out_or_logical),
        .out_not(out_not)
    );
endmodule