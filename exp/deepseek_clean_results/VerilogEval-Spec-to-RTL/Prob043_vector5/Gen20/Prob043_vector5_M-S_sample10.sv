module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Unique comparisons only (lower triangular matrix + diagonal)
    // Self-comparisons are always 1, other comparisons are computed once
    assign out = {
        // Row 1 (a)
        1'b1, a ~^ b, a ~^ c, a ~^ d, a ~^ e,
        // Row 2 (b)
        b ~^ a, 1'b1, b ~^ c, b ~^ d, b ~^ e,
        // Row 3 (c)
        c ~^ a, c ~^ b, 1'b1, c ~^ d, c ~^ e,
        // Row 4 (d)
        d ~^ a, d ~^ b, d ~^ c, 1'b1, d ~^ e,
        // Row 5 (e)
        e ~^ a, e ~^ b, e ~^ c, e ~^ d, 1'b1
    };

endmodule