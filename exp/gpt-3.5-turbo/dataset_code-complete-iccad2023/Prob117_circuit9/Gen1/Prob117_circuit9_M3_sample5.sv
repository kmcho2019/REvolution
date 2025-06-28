module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

always @ (posedge clk) begin
  if (a == 1'b1 && q < 3'd6) begin
    q <= q + 1; // Increment counter when 'a' is high and q is less than 6
  end else if (a == 1'b0) begin
    q <= 3'b0; // Reset counter to 0 when 'a' transitions from high to low
  end
end

endmodule