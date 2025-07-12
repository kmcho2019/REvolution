module TopModule (
    input  [3:0] x, // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);

    // Assign input bits for clarity
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    /*
      The Karnaugh map is indexed by (x4 x3) as rows and (x2 x1) as columns,
      with values given and don't-cares allowing freedom.

      From the map:

      Rows\Cols  00    01    11    10
        00     d(0)   0     d(0)  d(0)
        01      0    d(0)    1     0
        11      1     1    d(0)   d(0)
        10      1     1     0     d(0)

      Treat all don't-cares as 0 to simplify boolean expression.

      Let's denote:
      R1 = x4 (MSB of row)
      R0 = x3 (LSB of row)
      C1 = x2 (MSB of col)
      C0 = x1 (LSB of col)

      Now, define the function f(R1,R0,C1,C0):

      From the minterms (f=1):

      - (R1,R0,C1,C0) = (1,1,0,0) = 1100 = 12 decimal
      - (1,1,0,1) = 1101 = 13 decimal
      - (0,1,1,1) = 0111 = 7 decimal
      - (1,0,0,0) = 1000 = 8 decimal
      - (1,0,0,1) = 1001 = 9 decimal

      These five minterms correspond to:

      decimal: 7,8,9,12,13

      In sum-of-products form:
        f = m7 + m8 + m9 + m12 + m13

      Converting these to product terms:

      m7:  0 1 1 1 => ~R1 R0 C1 C0
      m8:  1 0 0 0 => R1 ~R0 ~C1 ~C0
      m9:  1 0 0 1 => R1 ~R0 ~C1 C0
      m12: 1 1 0 0 => R1 R0 ~C1 ~C0
      m13: 1 1 0 1 => R1 R0 ~C1 C0

      Simplify by grouping minterms:

      - Group m8 and m9:
        R1 ~R0 ~C1 (covers both C0=0 and 1)
      - Group m12 and m13:
        R1 R0 ~C1 (covers both C0=0 and 1)
      - m7 is alone: ~R1 R0 C1 C0

      So final SOP:
        f = (~R1 & R0 & C1 & C0) | (R1 & ~C1 & (~R0 | R0))
      Since (~R0 | R0) is always true,
      => f = (~R1 & R0 & C1 & C0) | (R1 & ~C1)

    So the final expression is:
      f = (x4' & x3 & x2 & x1) | (x4 & ~x2)

    This is a minimal, clean logic expression directly from the Karnaugh map,
    no Gray decoding needed.
    */

    assign f = (~x4 & x3 & x2 & x1) | (x4 & ~x2);

endmodule