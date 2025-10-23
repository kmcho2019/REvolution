module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Systematic 5x5 comparison matrix with optimized self-comparisons
    // Grouped by input operand for maximum clarity
    assign out[24:20] = {1'b1,    a ~^ b, a ~^ c, a ~^ d, a ~^ e};  // a comparisons
    assign out[19:15] = {b ~^ a, 1'b1,    b ~^ c, b ~^ d, b ~^ e};  // b comparisons
    assign out[14:10] = {c ~^ a, c ~^ b, 1'b1,    c ~^ d, c ~^ e};  // c comparisons
    assign out[9:5]   = {d ~^ a, d ~^ b, d ~^ c, 1'b1,    d ~^ e};  // d comparisons
    assign out[4:0]   = {e ~^ a, e ~^ b, e ~^ c, e ~^ d, 1'b1};    // e comparisons

endmodule