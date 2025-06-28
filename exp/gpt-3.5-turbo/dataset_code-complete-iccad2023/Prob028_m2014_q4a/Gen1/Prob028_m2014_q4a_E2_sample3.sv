module TopModule (
  input d,
  input ena,
  output logic q
);
  always @(posedge d)
  begin
    if(ena)
      q <= d;
  end
endmodule