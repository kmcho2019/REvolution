module TopModule (
  input d,
  input ena,
  output logic q
);

  logic stored_d;

  always @(posedge d) begin
    stored_d <= d;
  end

  always @(posedge ena) begin
    if (ena)
      q <= stored_d;
  end

endmodule