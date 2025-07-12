module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Single concatenation with optimized self-comparisons and clear grouping
    assign out = {
        // a comparisons (a-a to a-e)
        1'b1,    a ~^ b, a ~^ c, a ~^ d, a ~^ e,
        // b comparisons (b-a to b-e)
        b ~^ a, 1'b1,    b ~^ c, b ~^ d, b ~^ e,
        // c comparisons (c-a to c-e)
        c ~^ a, c ~^ b, 1'b1,    c ~^ d, c ~^ e,
        // d comparisons (d-a to d-e)
        d ~^ a, d ~^ b, d ~^ c, 1'b1,    d ~^ e,
        // e comparisons (e-a to e-e)
        e ~^ a, e ~^ b, e ~^ c, e ~^ d, 1'b1
    };

endmodule