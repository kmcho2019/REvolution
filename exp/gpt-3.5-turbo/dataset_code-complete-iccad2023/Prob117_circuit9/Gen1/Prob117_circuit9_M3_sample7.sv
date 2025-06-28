module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

always @ (posedge clk) begin
  if (a == 1 && q < 6) // Increment counter when 'a' is high and limit is not reached
    q <= q + 1;
  else if (a == 0) // Reset counter when 'a' transitions from high to low
    q <= 0;
end

endmodule