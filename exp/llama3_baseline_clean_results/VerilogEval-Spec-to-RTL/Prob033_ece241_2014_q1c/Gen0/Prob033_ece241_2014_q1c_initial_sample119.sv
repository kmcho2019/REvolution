module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    // Calculate the sum of the two numbers
    assign s = a + b;

    // Check for overflow
    assign overflow = (a[7] == b[7] && a[7] != s[7]);

endmodule