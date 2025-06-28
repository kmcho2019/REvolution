module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg a_prev;

always @ (posedge clk) begin
  if (a == 1'b1 && a_prev == 1'b0) begin
    // Increment counter when 'a' transitions from 0 to 1
    if (q < 3'd6)
      q <= q + 1;
  end else if (a == 1'b0 && a_prev == 1'b0) begin
    // Reset counter to 0 only when 'a' is continuously low
    q <= 3'b0;
  end

  a_prev <= a;
end

endmodule