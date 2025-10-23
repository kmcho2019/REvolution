module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    assign out = {
        // a comparisons (a-a to a-e)
        1'b1,    // a==a
        a == b,  // a==b
        a == c,  // a==c
        a == d,  // a==d
        a == e,  // a==e
        
        // b comparisons (b-a to b-e)
        b == a,  // b==a
        1'b1,    // b==b
        b == c,  // b==c
        b == d,  // b==d
        b == e,  // b==e
        
        // c comparisons (c-a to c-e)
        c == a,  // c==a
        c == b,  // c==b
        1'b1,    // c==c
        c == d,  // c==d
        c == e,  // c==e
        
        // d comparisons (d-a to d-e)
        d == a,  // d==a
        d == b,  // d==b
        d == c,  // d==c
        1'b1,    // d==d
        d == e,  // d==e
        
        // e comparisons (e-a to e-e)
        e == a,  // e==a
        e == b,  // e==b
        e == c,  // e==c
        e == d,  // e==d
        1'b1     // e==e
    };

endmodule