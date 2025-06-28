module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

always @ (posedge clk) begin
  if (a == 1 && q < 6) begin
    q <= q + 1; // Increment counter when 'a' is high and q is less than 6
  end else if (a == 0) begin
    q <= q & ~a; // Reset counter to 0 when 'a' is low continuously
  end
end

endmodule