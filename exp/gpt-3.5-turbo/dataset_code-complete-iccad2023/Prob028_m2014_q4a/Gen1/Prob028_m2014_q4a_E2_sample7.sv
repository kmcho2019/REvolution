module TopModule (
  input d,
  input ena,
  output logic q
);
  
  always @(posedge ena) begin
    q <= d;
  end

endmodule