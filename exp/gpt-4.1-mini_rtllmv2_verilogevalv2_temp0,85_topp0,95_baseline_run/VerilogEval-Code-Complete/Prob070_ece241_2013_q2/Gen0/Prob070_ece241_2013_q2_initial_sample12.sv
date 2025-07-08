module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

// Minterms for output=1: 2(0010), 7(0111), 15(1111)
// SOP minimization:
// minterms: m2, m7, m15
// Let's write the expressions for each minterm:
// m2 = a' b' c  d'
// m7 = a' b  c  d
// m15= a  b  c  d
// Try to combine:
// m7 and m15: differ only in a (0 vs 1), so combine to b c d
// m2 and m7: differ in b (0 vs 1) and d (0 vs 1), no direct combination
// So SOP = b c d + a' b' c d'

assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

// Maxterms for output=0: 0,1,4,5,6,9,10,13,14
// Let's find maxterms (product of sums):
// For POS, the output is 0 for these inputs, so maxterms correspond to these numbers.
// Maxterm expression is product of sums that are 0 at these inputs.

// Write the maxterm literals for each:
// 0  = 0000 => (a + b + c + d)
// 1  = 0001 => (a + b + c + ~d)
// 4  = 0100 => (a + ~b + c + d)
// 5  = 0101 => (a + ~b + c + ~d)
// 6  = 0110 => (a + ~b + ~c + d)
// 9  = 1001 => (~a + b + c + ~d)
// 10 = 1010 => (~a + b + ~c + d)
// 13 = 1101 => (~a + ~b + c + ~d)
// 14 = 1110 => (~a + ~b + ~c + d)

// Now minimize the POS:
// Group terms to find common factors. Observing terms:
// (a + b + c + d) and (a + b + c + ~d) => (a + b + c)
// (a + ~b + c + d) and (a + ~b + c + ~d) => (a + ~b + c)
// (a + ~b + ~c + d) => separate term
// (~a + b + c + ~d), (~a + b + ~c + d), (~a + ~b + c + ~d), (~a + ~b + ~c + d)

// Let's try to factor further:
// From above:
// (a + b + c)
// (a + ~b + c)
// (a + ~b + ~c + d)
// (~a + b + c + ~d)
// (~a + b + ~c + d)
// (~a + ~b + c + ~d)
// (~a + ~b + ~c + d)

// Try to simplify further using consensus or Karnaugh map.

// Alternatively, implement the product of these maxterms directly in Verilog:

wire m0  = (a | b | c | d);
wire m1  = (a | b | c | ~d);
wire m4  = (a | ~b | c | d);
wire m5  = (a | ~b | c | ~d);
wire m6  = (a | ~b | ~c | d);
wire m9  = (~a | b | c | ~d);
wire m10 = (~a | b | ~c | d);
wire m13 = (~a | ~b | c | ~d);
wire m14 = (~a | ~b | ~c | d);

assign out_pos = m0 & m1 & m4 & m5 & m6 & m9 & m10 & m13 & m14;

endmodule