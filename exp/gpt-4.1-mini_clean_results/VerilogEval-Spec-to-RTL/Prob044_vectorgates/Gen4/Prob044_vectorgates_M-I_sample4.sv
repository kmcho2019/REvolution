module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    wire [2:0] or_result;

    // Compute bitwise OR once and reuse
    assign or_result = a | b;
    assign out_or_bitwise = or_result;

    // Logical OR reduction of bitwise OR result
    assign out_or_logical = |or_result;

    // Concatenate inverted inputs as required
    assign out_not = {~b, ~a};

endmodule