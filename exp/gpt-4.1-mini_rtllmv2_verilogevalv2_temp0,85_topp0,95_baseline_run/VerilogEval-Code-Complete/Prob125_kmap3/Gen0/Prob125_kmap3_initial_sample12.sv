module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @(*) begin
    // Map inputs to variables for clarity
    // ab = {a,b}, cd = {c,d}
    // K-map cells:
    // cd=00 (c=0,d=0): ab=01(d),00(0),10(1),11(1)
    // cd=01 (c=0,d=1): ab=01(0),00(0),10(d),11(d)
    // cd=11 (c=1,d=1): ab=01(0),00(1),10(1),11(1)
    // cd=10 (c=1,d=0): ab=01(0),00(1),10(1),11(1)

    // After minimization considering don't cares:
    // Expression derived:
    // 1) Group of 1s in ab=11 & cd=00,11,10 => (a & b)
    // 2) Group of 1s in ab=10 & cd=00,11,10 => (a & ~b)
    // 3) Group of 1s in ab=00 & cd=11,10 => (~a & ~b & c)
    // 4) Single 1 at ab=10, cd=00 => (a & ~b & ~c & ~d) but covered by (a & ~b)
    //
    // So final minimized expression:
    // out = a & b | a & ~b | ~a & ~b & c
    //
    // Simplify a & b | a & ~b = a
    // Thus, out = a | (~a & ~b & c)
    //
    // Final: out = a + (~a & ~b & c)

    out = a | (~a & ~b & c);
  end

endmodule