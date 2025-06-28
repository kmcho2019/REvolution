module TopModule (
  input d,
  input ena,
  output logic q
);
  
  always @ (ena)
    if (ena)
      q <= d;
  
endmodule