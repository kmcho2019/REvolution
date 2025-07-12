module TopModule (
  input clk,
  input L,
  input r_in,
  output reg Q
);

  always @(posedge clk) begin
    if (L) begin
      Q <= r_in;
    end
  end

endmodule