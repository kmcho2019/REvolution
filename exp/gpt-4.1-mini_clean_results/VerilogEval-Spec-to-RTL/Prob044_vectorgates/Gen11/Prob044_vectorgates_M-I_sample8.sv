module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Compute bitwise OR once
    wire [2:0] or_result = a | b;

    // Assign bitwise OR output
    assign out_or_bitwise = or_result;

    // Logical OR reduction on precomputed OR result
    assign out_or_logical = |or_result;

    // Invert b in upper half, invert a in lower half
    assign out_not = {~b, ~a};

endmodule