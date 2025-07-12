module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (a & b) | (a & b & c) | (a & ~b & c) | (~a & b & c) | (~a & ~b & c);

// Further simplification of the logic considering 'd' as don't care and 
// the conditions when 'out' is high
// The condition a'b'c' is covered by the first and last terms in the assign statement
// when considering 'a' and 'b' and their impact on 'out'
// Thus the simplified form focusing on 'ab' or 'a'bc or 'a'b'c' can be achieved directly
// But given the K-map, 'ab' covers several cases, hence focusing on these three main conditions
// provides a direct implementation

endmodule