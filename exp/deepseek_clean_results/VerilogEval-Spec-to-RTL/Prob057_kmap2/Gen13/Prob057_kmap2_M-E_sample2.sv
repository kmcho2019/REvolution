module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Pattern matchers for each '1' in the K-map
wire pattern1 = (~a & ~b & ~c & ~d);  // 0000
wire pattern2 = (~a & ~b & ~c & d);   // 0001
wire pattern3 = (~a & ~b & c & ~d);   // 0010
wire pattern4 = (~a & b & ~c & ~d);   // 0100
wire pattern5 = (~a & b & c & d);     // 0111
wire pattern6 = (a & ~b & ~c & ~d);   // 1000
wire pattern7 = (a & ~b & ~c & d);    // 1001
wire pattern8 = (a & b & ~c & d);     // 1101
wire pattern9 = (a & b & c & ~d);     // 1110

// Combine all patterns
assign out = pattern1 | pattern2 | pattern3 | 
             pattern4 | pattern5 | pattern6 | 
             pattern7 | pattern8 | pattern9;

endmodule