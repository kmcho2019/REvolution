module TopModule (
  input d,
  input ena,
  output logic q
);

  always @(posedge ena) begin
    if (ena) begin
      q <= d;
    end
  end

endmodule