module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Hierarchical decision tree based on K-map structure
assign out = (~c & ~d) ? ( // cd = 00
                (~a & ~b) | (~a & b) | (a & ~b)  // 1,1,0,1 pattern
              ) : (~c & d) ? ( // cd = 01
                (~a & ~b) | (a & ~b)             // 1,0,0,1 pattern
              : (c & d) ? (    // cd = 11
                (~a & b) | (a & b) | (a & ~b)     // 0,1,1,1 pattern
              : /* cd=10 */ (  // cd = 10
                (~a & ~b) | (~a & b)              // 1,1,0,0 pattern
              );

endmodule