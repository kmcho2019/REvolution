module TopModule (
  input [4:1] x,
  output logic f
);
  // Let x[4], x[3], x[2], x[1]
  // K-map rows: x[3]x[4], cols: x[1]x[2]
  // Using given K-map to find minimal SOP:
  // From K-map:
  // 1) Group the ones in the bottom two rows and left two columns:
  //    Covers (x[3]x[4])=11 or 10 and (x[1]x[2])=00 or 01
  //    This corresponds to x[3] = 1 (since rows 11 and 10 both have x[3]=1)
  //    and x[2]' = 1 (because columns 00 and 01 correspond to x[2]=0)
  //    So group1: x[3] & ~x[2]
  //
  // 2) Group the ones in row 11, columns 01 and 11 (x[3]x[4]=11, x[1]x[2]=01 or 11)
  //    Here, x[3]=1, x[4]=1; columns 01 and 11 mean x[1]=0 and x[1]=1 respectively (so x[1] is irrelevant)
  //    but x[2]=1 in both. So group2: x[3] & x[4] & x[2]
  //
  // 3) Group the single 1 at row 01, column 11 (x[3]x[4]=01, x[1]x[2]=11)
  //    This is x[3]=0, x[4]=1, x[1]=1, x[2]=1
  //    So group3: ~x[3] & x[4] & x[1] & x[2]
  //
  // However, including this last minterm doesn't simplify the function well.
  // Check if we can use don't-cares to cover this 1 with larger groups:
  // The 1 at (01,11) is surrounded by don't-cares at (00,11), (01,10), (00,10),
  // but none are 1s to group with, so this is a single minterm.
  //
  // So final expression:
  // f = (x[3] & ~x[2]) | (x[3] & x[4] & x[2]) | (~x[3] & x[4] & x[1] & x[2])
  //
  // Implement this in Verilog.
  
  assign f = (x[3] & ~x[2]) | (x[3] & x[4] & x[2]) | (~x[3] & x[4] & x[1] & x[2]);
endmodule