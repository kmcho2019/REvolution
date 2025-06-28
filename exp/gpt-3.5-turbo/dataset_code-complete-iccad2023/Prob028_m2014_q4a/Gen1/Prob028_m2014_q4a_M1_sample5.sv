module TopModule (
  input d,
  input ena,
  output logic q
);

  always @(ena or posedge ena) begin
    if (ena)
      q <= d;
  end

endmodule