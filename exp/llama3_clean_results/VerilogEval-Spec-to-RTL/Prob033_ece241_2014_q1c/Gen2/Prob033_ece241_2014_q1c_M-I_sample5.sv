module TopModule (
    input  [7:0] a, // 8-bit 2's complement number
    input  [7:0] b, // 8-bit 2's complement number
    output [7:0] s, // Sum of a and b
    output logic overflow // Indicates if a signed overflow occurred
);

    // Calculate the sum of a and b
    assign s = a + b;
    
    // Detect overflow by comparing the sign bits of a, b, and s
    // An overflow occurs if the sign bits of a and b are the same but different from the sign bit of s
    // We can optimize the logic slightly by directly comparing the MSBs without extra operations
    assign overflow = (a[7] == b[7]) && (a[7] != s[7]);

endmodule