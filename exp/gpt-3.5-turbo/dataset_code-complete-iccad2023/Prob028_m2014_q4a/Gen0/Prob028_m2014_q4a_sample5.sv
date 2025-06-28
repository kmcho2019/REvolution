module TopModule (
  input d,
  input ena,
  output logic q
);
  
  always @ (posedge ena)
    if (ena)
      q <= d;
  
endmodule