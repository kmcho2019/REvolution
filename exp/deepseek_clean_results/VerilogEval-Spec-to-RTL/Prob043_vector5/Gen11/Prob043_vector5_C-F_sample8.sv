module TopModule (
    input  a, b, c, d, e,
    output [24:0] out
);

    // Output ordering: [24:20] a vs all, [19:15] b vs all, 
    // [14:10] c vs all, [9:5] d vs all, [4:0] e vs all
    assign out = {
        /* a comparisons */ {a ~^ a, a ~^ b, a ~^ c, a ~^ d, a ~^ e},
        /* b comparisons */ {b ~^ a, b ~^ b, b ~^ c, b ~^ d, b ~^ e},
        /* c comparisons */ {c ~^ a, c ~^ b, c ~^ c, c ~^ d, c ~^ e},
        /* d comparisons */ {d ~^ a, d ~^ b, d ~^ c, d ~^ d, d ~^ e},
        /* e comparisons */ {e ~^ a, e ~^ b, e ~^ c, e ~^ d, e ~^ e}
    };

endmodule