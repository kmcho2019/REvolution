module TopModule (
  input clk,
  input in,
  output logic out
);

  always @(posedge clk) begin
    out <= in ^ out;
  end

endmodule