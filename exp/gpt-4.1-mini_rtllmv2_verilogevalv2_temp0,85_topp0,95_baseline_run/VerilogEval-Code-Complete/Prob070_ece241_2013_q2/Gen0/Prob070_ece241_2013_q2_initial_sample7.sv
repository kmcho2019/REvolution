module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);
  // Inputs as 4-bit vector for clarity
  wire [3:0] in = {a,b,c,d};

  // Minterms for output=1: 2,7,15
  // Don't cares: 3,8,11,12
  // Let's write out minterms in binary:
  // 2 = 0010 (a=0,b=0,c=1,d=0)
  // 7 = 0111 (a=0,b=1,c=1,d=1)
  // 15=1111 (a=1,b=1,c=1,d=1)
  //
  // Using Karnaugh map simplification with don't cares 3,8,11,12:
  // The simplified SOP is: c & d | b & c & d
  // Actually, let's simplify properly:
  //
  // From the inputs:
  // 2 = 0 0 1 0
  // 7 = 0 1 1 1
  // 15= 1 1 1 1
  // Don't cares: 3(0 0 1 1),8(1 0 0 0),11(1 0 1 1),12(1 1 0 0)
  //
  // Combine 2(0010) and 3(0011) don't care to cover c=1, b=0,a=0,d=-
  // Combine 7(0111) and 15(1111) for b=1,c=1,d=1,a=-
  //
  // So SOP minimal:
  // out_sop = (~a & ~b & c) | (b & c & d)
  //
  // For POS minimal:
  // zeros at 0,1,4,5,6,9,10,13,14
  // We'll use maxterms and don't cares to simplify.
  //
  // After simplification, the minimal POS is:
  // out_pos = (a + b + ~c) & (a + ~b + d)
  //
  // Implement these expressions:

  wire term1 = ~a & ~b & c;
  wire term2 = b & c & d;
  assign out_sop = term1 | term2;

  assign out_pos = (a | b | ~c) & (a | ~b | d);

endmodule