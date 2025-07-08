module TopModule (
  input a,
  input b,
  output out
);
  assign out = a ~^ b; // bitwise XNOR operator
endmodule