module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @(*) begin
    // According to the Karnaugh map:
    // ab columns: 01(1),00(0),10(2),11(3) with bits: b is LSB, a MSB
    // cd rows: 00(0),01(1),11(3),10(2)
    // Let's rewrite the Karnaugh map with corresponding minterms:
    // cd\ab| 01 | 00 | 10 | 11
    // 00   | d  | 0  | 1  | 1
    // 01   | 0  | 0  | d  | d
    // 11   | 0  | 1  | 1  | 1
    // 10   | 0  | 1  | 1  | 1

    // Assign variables for clarity: a,b,c,d are inputs (1-bit each)
    // We will consider a,b,c,d as bits in order: a,b for columns, c,d for rows.

    // Extract minterms where output is 1 (considering don't cares as needed):
    // (cd ab) = (c d a b)
    // Let's list all combinations and their output (1/0/d):
    // c d a b : out
    // 0 0 0 1 = 1 (d in map, treat as 1 if convenient)
    // 0 0 0 0 = 0
    // 0 0 1 0 = 1
    // 0 0 1 1 = 1
    // 0 1 0 1 = 0
    // 0 1 0 0 = 0
    // 0 1 1 0 = d
    // 0 1 1 1 = d
    // 1 1 0 1 = 0
    // 1 1 0 0 = 1
    // 1 1 1 0 = 1
    // 1 1 1 1 = 1
    // 1 0 0 1 = 0
    // 1 0 0 0 = 1
    // 1 0 1 0 = 1
    // 1 0 1 1 = 1

    // We see that whenever c=1, output is generally 1 except for a few cases.
    // Also, when a=1 and b=1 or b=0 and a=1 output is mostly 1.
    // Let's try to find groups:

    // Group 1: All cases where c=1 and d=anything -> out=1 except one case (c=1,d=1,a=0,b=1 = 0)
    // To simplify, let's choose don't-cares as 1 to cover max.

    // After analysis, simplified output expression:
    // out = c + (a & ~b) + (~a & b & ~c & ~d)

    // Implementing this expression in code.

    out = c | (a & ~b) | (~a & b & ~c & ~d);
  end

endmodule