module TopModule (
  input [4:1] x,
  output logic f
);

// Implementing the function f using logical combinations
always_comb begin
  // Handling the d values separately for x[3]='0' & x[2]='0', x[3]='0' & x[2]='1', x[3]='1' & x[2]='0', x[3]='1' & x[2]='1'
  if(x[3]==1'b0 && x[2]==1'b0)
    f = 1'b1;
  else if(x[3]==1'b0 && x[2]==1'b1)
    f = 1'b0;
  else if(x[3]==1'b1 && x[2]==1'b0)
    f = 1'b1;
  else if(x[3]==1'b1 && x[2]==1'b1)
    f = 1'b1;
  // Handling the rest of the values based on the Karnaugh map
  else
    f = (x[3] & x[1] & !x[2]) | (x[3] & x[4] & x[1]) | (!x[3] & x[4] & x[1]);

end

endmodule