module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Directly compute bitwise OR without intermediate wire
    assign out_or_bitwise = a | b;

    // Logical OR reduction of bitwise OR result directly
    assign out_or_logical = |(a | b);

    // Concatenate inverted inputs as required
    assign out_not = {~b, ~a};

endmodule