module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);
  always @(*) begin
    // Map variables: a,b are columns (ab=01,00,10,11)
    // c,d are rows (cd=00,01,11,10)
    // Indices: cd rows = c d; ab cols = a b
    // K-map (cd rows / ab columns):
    //      01  00  10  11  (ab)
    // 00 | d | 0 | 1 | 1 | (cd=00)
    // 01 | 0 | 0 | d | d | (cd=01)
    // 11 | 0 | 1 | 1 | 1 | (cd=11)
    // 10 | 0 | 1 | 1 | 1 | (cd=10)
    //
    // Use 0 for don't-care in coding, but will treat as either 0 or 1 for simplification.
    // Convert to minterms (a,b,c,d)
    // Let's write the ones and don't cares:
    //
    // 1's at:
    // cd=00 (c=0,d=0): ab=10(2),11(3) -> (a=1,b=0),(a=1,b=1)
    // cd=11 (c=1,d=1): ab=00(0),10(2),11(3) -> (a=0,b=0),(a=1,b=0),(a=1,b=1)
    // cd=10 (c=1,d=0): ab=00(0),10(2),11(3) -> (a=0,b=0),(a=1,b=0),(a=1,b=1)
    //
    // d's at:
    // cd=00 ab=01(1)
    // cd=01 ab=10(2),11(3)
    //
    // Grouping with don't cares chosen to simplify:
    //
    // Group 1: all cells where a=1 (ab=10 or 11) and c=1 (cd=11 or 10), output 1
    // - Covers (a=1,b=0 or 1,c=1,d=0 or 1)
    //
    // Group 2: all cells where a=1, c=0, d=0, b=0 or 1 (cd=00 ab=10,11)
    //
    // Group 3: cells where a=0,b=0,c=1 (cd=11 or 10 ab=00)
    //
    // Expression from groups:
    // G1: a & c
    // G2: a & ~c & ~d
    // G3: ~a & ~b & c
    //
    // Final expression: out = (a & c) | (a & ~c & ~d) | (~a & ~b & c)
    //
    // Implement this in always block.

    out = (a & c) | (a & ~c & ~d) | (~a & ~b & c);
  end
endmodule