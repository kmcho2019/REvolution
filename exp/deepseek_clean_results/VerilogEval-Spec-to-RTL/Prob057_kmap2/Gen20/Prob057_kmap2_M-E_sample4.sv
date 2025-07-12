module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate signals for pattern recognition
wire vertical_pattern = (a | b) & ~(a & b & c & d);  // ab=00 except cd=11
wire horizontal_pattern = (c | d) & ~(a & b & c & d); // cd=00 except ab=11
wire diagonal_pattern = (a ^~ c) & (b ^ d);           // a==c and b!=d
wire corner_case = (a & ~b & c & ~d) | (~a & b & ~c & d); // Specific corners

// Combine all patterns
assign out = vertical_pattern | horizontal_pattern | diagonal_pattern | corner_case;

endmodule