module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output reg overflow
);

// Perform the addition
assign s = a + b;

// Calculate the overflow by checking if the sign bits of a, b, and sum are consistent
assign overflow = (a[7] == b[7] && a[7] != s[7]);

endmodule