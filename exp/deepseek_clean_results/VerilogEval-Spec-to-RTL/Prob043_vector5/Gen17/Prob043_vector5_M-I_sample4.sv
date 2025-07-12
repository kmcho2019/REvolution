module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    assign out = {
        // Group 1: a comparisons (a~^a, a~^b, a~^c, a~^d, a~^e)
        a~^a, a~^b, a~^c, a~^d, a~^e,
        // Group 2: b comparisons (b~^a, b~^b, b~^c, b~^d, b~^e)
        b~^a, b~^b, b~^c, b~^d, b~^e,
        // Group 3: c comparisons (c~^a, c~^b, c~^c, c~^d, c~^e)
        c~^a, c~^b, c~^c, c~^d, c~^e,
        // Group 4: d comparisons (d~^a, d~^b, d~^c, d~^d, d~^e)
        d~^a, d~^b, d~^c, d~^d, d~^e,
        // Group 5: e comparisons (e~^a, e~^b, e~^c, e~^d, e~^e)
        e~^a, e~^b, e~^c, e~^d, e~^e
    };

endmodule