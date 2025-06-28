module TopModule (
  input d,
  input ena,
  output logic q
);

  logic temp;

  always @(posedge ena) begin
    temp <= d;
  end

  always @(posedge d) begin
    q <= temp;
  end

endmodule