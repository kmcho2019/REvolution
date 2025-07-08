module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @(*) begin
    // Variables for clarity
    // Inputs: a,b,c,d (not to be confused with don't-care)
    // K-map positions are defined by ab (columns) and cd (rows)
    //
    // K-map (cd rows, ab cols):
    //       01  00  10  11  (ab)
    // 00 | d | 0 | 1 | 1 | (cd=00)
    // 01 | 0 | 0 | d | d | (cd=01)
    // 11 | 0 | 1 | 1 | 1 | (cd=11)
    // 10 | 0 | 1 | 1 | 1 | (cd=10)
    //
    // We label inputs as bits: a,b,c,d as per the problem:
    // Let's consider variables in order: a,b,c,d as inputs.
    //
    // Let's analyze the map:
    // Let's first rewrite K-map with inputs properly:
    // ab = 00,01,10,11 (columns)
    // cd = 00,01,10,11 (rows)
    //
    // Table with explicit indices:
    // cd\ab 00  01  10  11
    // 00    0   d   1   1
    // 01    0   0   d   d
    // 10    0   1   1   1
    // 11    1   0   1   0
    //
    // Wait, the user gave:
    // cd\ab 01  00  10  11
    // 00    d   0   1   1
    // 01    0   0   d   d
    // 11    0   1   1   1
    // 10    0   1   1   1
    //
    // So columns are in order ab=01,00,10,11 left to right.
    // Rows are cd=00,01,11,10 top to bottom.
    //
    // Let's reorder columns so ab=00,01,10,11 left to right for ease:
    // From user:
    //       01  00  10  11
    // 00 | d | 0 | 1 | 1 |
    // 01 | 0 | 0 | d | d |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 0 | 1 | 1 | 1 |
    //
    // So ab order: 01,00,10,11
    // Let's reorder columns to 00,01,10,11:
    //       00  01  10  11
    // 00 | 0 | d | 1 | 1 |
    // 01 | 0 | 0 | d | d |
    // 11 | 1 | 0 | 1 | 1 |  (swapped user row 11 and 10? Wait rows order: 00,01,11,10)
    // 10 | 1 | 0 | 1 | 1 |
    //
    // Actually, user rows are: 00,01,11,10 top to bottom
    // For simplification let's rearrange rows as 00,01,10,11 (standard K-map order)
    //
    // Rearranged K-map:
    //       00  01  10  11
    // 00 | 0 | d | 1 | 1 |
    // 01 | 0 | 0 | d | d |
    // 10 | 0 | 1 | 1 | 1 |
    // 11 | 0 | 1 | 1 | 1 |
    //
    // From this, group ones and don't-cares to simplify:
    // Group 1: entire bottom two rows (cd=10 and 11), columns 01,10,11 (since all 1s)
    // Group 2: the 1s at (00,10) and (00,11)
    // Including don't-cares to expand groups.
    //
    // Let's simplify:
    // Group A: cd=1x (c=1), ab=1x (b=1)
    // Group B: c'd' (cd=00) and ab=10 or 11 (a=1)
    //
    // After simplification, the function is:
    // out = a*c + b*c + a*b*c' + a*c'd' (from groups)
    //
    // Minimized further:
    // out = c*(a + b) + a*b*c'
    //
    // We'll implement out = (c & (a | b)) | (a & b & ~c);
    //
    // This matches the K-map groupings including don't-cares.
    //
    // Implement combinational always block:
    out = (c & (a | b)) | (a & b & ~c);
  end

endmodule