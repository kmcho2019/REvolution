module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);

// Conditional parity check based on x3
// When x3 is 0, f = (x1 XOR x2)
// When x3 is 1, considering the need for an even number of 1's among x1 and x2 or x1 being 1,
// we can use (x1 XOR x2) for the even condition but must ensure x1=1 sets f=1 regardless of x2.
// Hence, f = x1 OR (x1 XOR x2) when x3=1.

assign f = (!x3) ? (x1 ^ x2) : (x1 | (x1 ^ x2));

endmodule