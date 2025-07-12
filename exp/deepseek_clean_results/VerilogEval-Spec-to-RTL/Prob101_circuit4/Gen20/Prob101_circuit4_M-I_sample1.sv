module TopModule (
    input  a,      // Unused input (required by interface)
    input  b,      // OR operand 1 - q = 1 when b = 1 (independent of a,c,d)
    input  c,      // OR operand 2 - q = 1 when c = 1 (independent of a,b,d)
    input  d,      // Unused input (required by interface)
    output q       // Output: Logical OR of b and c (q = b | c)
);

    // Truth Table Implementation:
    // Time  b c | q
    // ---------|---
    // 25-50 0 1 | 1
    // 25-50 1 0 | 1
    // 25-50 1 1 | 1
    // else     | 0
    // Note: a and d are don't-cares for q
    assign q = b | c;

    // PPA Characteristics:
    // - Single gate delay (OR2)
    // - Zero hold/setup violations
    // - Minimal power/area (1 standard cell)
endmodule