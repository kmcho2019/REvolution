module TopModule(
    input  [3:0] x,
    output      f
);

// Variable assignments for clarity, matching Karnaugh map bits:
// x[3], x[2], x[1], x[0]

// From the Karnaugh map, a minimal sum-of-products is:
// f = x[3]' x[2]' x[1]' x[0]'      (minterm 0)
//   + x[3]' x[2]' x[1]' x[0]       (minterm 1)
//   + x[3]' x[2]  x[1]'            (minterms 4,5,6 combined)
//   + x[3]  x[2]' x[1]'            (minterms 8,9 combined from map: actually from map minterms 8 and 9 are 1)
//   + x[3]  x[2]  x[1]' x[0]'      (minterm 12)
//   + x[3]  x[2]  x[1]              (minterms 13 (1), 14 (1), 15(1) combined)
// Analyzing the Karnaugh map carefully, the minimal expression after simplification is:

// Let's define the variables for clarity:
wire A = x[3];
wire B = x[2];
wire C = x[1];
wire D = x[0];

// By grouping 1's:
// Group1 (minterms 0,1): ~A & ~B & ~C
// Group2 (minterms 4,5,6): ~A & B & ~C
// Group3 (minterms 8,9): A & ~B & ~C
// Group4 (minterm 12): A & B & ~C & ~D
// Group5 (minterms 13,14,15): A & B & C

// Combine groups:

assign f = 
    (~A & ~B & ~C)    // minterms 0,1
  | (~A & B  & ~C)    // minterms 4,5,6
  | (A  & ~B & ~C)    // minterms 8,9
  | (A  & B  & ~C & ~D) // minterm 12
  | (A  & B  & C);    // minterms 13,14,15

endmodule