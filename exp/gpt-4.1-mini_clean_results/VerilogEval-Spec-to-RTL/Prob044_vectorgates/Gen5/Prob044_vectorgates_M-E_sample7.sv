module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    wire [2:0] bitwise_or_result;
    wire [5:0] inverted_concat;

    // Compute bitwise OR of inputs a and b
    assign bitwise_or_result = a | b;

    // Compute logical OR by reducing OR of bitwise OR result
    assign out_or_logical = |bitwise_or_result;

    // Concatenate inverse of b (upper bits) and inverse of a (lower bits)
    assign inverted_concat = { ~b, ~a };

    // Assign outputs from intermediate signals
    assign out_or_bitwise = bitwise_or_result;
    assign out_not       = inverted_concat;

endmodule