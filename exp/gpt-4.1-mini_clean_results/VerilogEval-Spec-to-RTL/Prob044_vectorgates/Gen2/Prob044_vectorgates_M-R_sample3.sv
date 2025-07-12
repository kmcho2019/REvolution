module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Compute bitwise OR of inputs directly in output assignment
    assign out_or_bitwise = a | b;

    // Logical OR is reduction OR of bitwise OR result computed inline
    assign out_or_logical = |(a | b);

    // Concatenate inverted b and inverted a for out_not output
    assign out_not = { ~b, ~a };

endmodule