module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output        overflow
);

    // Compute the sum of the two input numbers
    assign s = a + b;

    // Check for signed overflow by comparing the most significant bits
    assign overflow = (a[7] == b[7] && a[7] != s[7]);

endmodule