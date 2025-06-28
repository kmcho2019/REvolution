module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg reset_requested;

always @(posedge clk) begin
  if (a == 1 && !reset_requested) begin
    if (q < 6)
      q <= q + 1;
  end else begin
    reset_requested <= 1;
  end
end

always @(posedge clk) begin
  if (a == 0)
    reset_requested <= 0; // Reset only when 'a' is continuously low
end

endmodule