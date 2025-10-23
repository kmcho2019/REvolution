module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Comparison matrix (5x5 = 25 comparisons)
    // Format: out[bit] = input_row ~^ input_col
    
    // Row 1: a compared with all inputs (including self)
    assign out[24:20] = {
        a ~^ a,  // a == a
        a ~^ b,  // a == b
        a ~^ c,  // a == c
        a ~^ d,  // a == d
        a ~^ e   // a == e
    };

    // Row 2: b compared with all inputs
    assign out[19:15] = {
        b ~^ a,  // b == a
        b ~^ b,  // b == b
        b ~^ c,  // b == c
        b ~^ d,  // b == d
        b ~^ e   // b == e
    };

    // Row 3: c compared with all inputs
    assign out[14:10] = {
        c ~^ a,  // c == a
        c ~^ b,  // c == b
        c ~^ c,  // c == c
        c ~^ d,  // c == d
        c ~^ e   // c == e
    };

    // Row 4: d compared with all inputs
    assign out[9:5] = {
        d ~^ a,  // d == a
        d ~^ b,  // d == b
        d ~^ c,  // d == c
        d ~^ d,  // d == d
        d ~^ e   // d == e
    };

    // Row 5: e compared with all inputs
    assign out[4:0] = {
        e ~^ a,  // e == a
        e ~^ b,  // e == b
        e ~^ c,  // e == c
        e ~^ d,  // e == d
        e ~^ e   // e == e
    };

endmodule