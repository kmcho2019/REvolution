module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Systematic grouping of all comparisons in required order
    assign out = {
        // Group 1: a vs all (a-a to a-e)
        a~^a, a~^b, a~^c, a~^d, a~^e,
        // Group 2: b vs all (b-a to b-e)
        b~^a, b~^b, b~^c, b~^d, b~^e,
        // Group 3: c vs all (c-a to c-e)
        c~^a, c~^b, c~^c, c~^d, c~^e,
        // Group 4: d vs all (d-a to d-e)
        d~^a, d~^b, d~^c, d~^d, d~^e,
        // Group 5: e vs all (e-a to e-e)
        e~^a, e~^b, e~^c, e~^d, e~^e
    };

endmodule