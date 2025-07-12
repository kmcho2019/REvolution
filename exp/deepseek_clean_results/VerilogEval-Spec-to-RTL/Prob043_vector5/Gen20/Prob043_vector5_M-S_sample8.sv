module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    assign out = {
        // Row 1: a comparisons
        1'b1,    a ~^ b, a ~^ c, a ~^ d, a ~^ e,
        // Row 2: b comparisons
        b ~^ a, 1'b1,    b ~^ c, b ~^ d, b ~^ e,
        // Row 3: c comparisons
        c ~^ a, c ~^ b, 1'b1,    c ~^ d, c ~^ e,
        // Row 4: d comparisons
        d ~^ a, d ~^ b, d ~^ c, 1'b1,    d ~^ e,
        // Row 5: e comparisons
        e ~^ a, e ~^ b, e ~^ c, e ~^ d, 1'b1
    };

endmodule