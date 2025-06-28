module TopModule (
  input d,
  input ena,
  output logic q
);

  always @ (d) begin
    if (ena) begin
      q <= d;
    end
  end

endmodule