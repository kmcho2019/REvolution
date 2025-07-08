module TopModule (
  input d,
  input ena,
  output logic q
);

always @(*) begin
  if (ena)
    q = d;
  // else retain previous value of q (no else needed because latch holds value)
end

endmodule