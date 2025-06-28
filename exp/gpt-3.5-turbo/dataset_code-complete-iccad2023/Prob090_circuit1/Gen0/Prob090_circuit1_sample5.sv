module TopModule (
  input a,
  input b,
  output q
);
  
  assign q = a & b; // Output q is 1 when both inputs a and b are 1, otherwise 0

endmodule