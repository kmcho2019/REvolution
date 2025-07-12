module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);
    // Row-major order assignment of the comparison matrix
    assign out = {
        // Row 1 (a vs all)
        1'b1,        // a~a
        a ~^ b,      // a~b
        a ~^ c,      // a~c
        a ~^ d,      // a~d
        a ~^ e,      // a~e
        
        // Row 2 (b vs all)
        b ~^ a,      // b~a
        1'b1,        // b~b
        b ~^ c,      // b~c
        b ~^ d,      // b~d
        b ~^ e,      // b~e
        
        // Row 3 (c vs all)
        c ~^ a,      // c~a
        c ~^ b,      // c~b
        1'b1,        // c~c
        c ~^ d,      // c~d
        c ~^ e,      // c~e
        
        // Row 4 (d vs all)
        d ~^ a,      // d~a
        d ~^ b,      // d~b
        d ~^ c,      // d~c
        1'b1,        // d~d
        d ~^ e,      // d~e
        
        // Row 5 (e vs all)
        e ~^ a,      // e~a
        e ~^ b,      // e~b
        e ~^ c,      // e~c
        e ~^ d,      // e~d
        1'b1         // e~e
    };
endmodule