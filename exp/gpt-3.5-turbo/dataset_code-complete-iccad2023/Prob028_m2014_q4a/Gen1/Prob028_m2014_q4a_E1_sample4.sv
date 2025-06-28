module TopModule (
  input d,
  input ena,
  output logic q
);

  always @(posedge ena or posedge d) begin
    if (ena)
      q <= d;
  end

endmodule