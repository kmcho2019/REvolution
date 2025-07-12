module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // The output implements the logic function from the Karnaugh map:
    // out = 1 for all input combinations except when a=0, b=0, and c=0.
    // This simplifies to a logical OR of the inputs.
    //
    // Benefits of this implementation:
    // - Minimal gate count: a single 3-input OR gate.
    // - Optimized for performance with minimal logic depth.
    // - Minimal power and area due to reduced gate usage.
    assign out = a | b | c;

endmodule