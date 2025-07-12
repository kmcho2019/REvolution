module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire term1 = ~(a | b | ~c | ~d);    // Covers ~a&~b&c&d when inverted
wire term2 = ~(~(a & b) | (c & d));  // Covers a&b&(~c|~d) cases
wire term3 = ~((~a | ~c) & (~b | d) & (a | ~d)); // Combined term for remaining patterns

assign out = ~(term1 & term2 & term3);  // Final NOR structure

endmodule