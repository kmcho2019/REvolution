module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Single assignment with all comparisons concatenated
    assign out = {
        // a comparisons (a-a to a-e)
        a~^a, a~^b, a~^c, a~^d, a~^e,
        // b comparisons (b-a to b-e)
        b~^a, b~^b, b~^c, b~^d, b~^e,
        // c comparisons (c-a to c-e)
        c~^a, c~^b, c~^c, c~^d, c~^e,
        // d comparisons (d-a to d-e)
        d~^a, d~^b, d~^c, d~^d, d~^e,
        // e comparisons (e-a to e-e)
        e~^a, e~^b, e~^c, e~^d, e~^e
    };

endmodule