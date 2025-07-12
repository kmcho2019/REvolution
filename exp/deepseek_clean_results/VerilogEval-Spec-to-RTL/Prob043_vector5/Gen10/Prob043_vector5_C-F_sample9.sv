module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Direct implementation using concatenation and XNOR operations
    // Grouped by first operand for clarity
    assign out = {
        // a comparisons (a-e)
        a ~^ a, a ~^ b, a ~^ c, a ~^ d, a ~^ e,
        
        // b comparisons (a-e)
        b ~^ a, b ~^ b, b ~^ c, b ~^ d, b ~^ e,
        
        // c comparisons (a-e)
        c ~^ a, c ~^ b, c ~^ c, c ~^ d, c ~^ e,
        
        // d comparisons (a-e)
        d ~^ a, d ~^ b, d ~^ c, d ~^ d, d ~^ e,
        
        // e comparisons (a-e)
        e ~^ a, e ~^ b, e ~^ c, e ~^ d, e ~^ e
    };

endmodule