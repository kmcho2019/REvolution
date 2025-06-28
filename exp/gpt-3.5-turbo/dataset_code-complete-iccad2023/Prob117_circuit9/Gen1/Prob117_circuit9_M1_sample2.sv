module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg [2:0] next_q;

always @ (posedge clk) begin
  if (a) begin
    if (q < 3'b110) // Increment the counter if 'a' is high
      next_q <= q + 3'd1;
    else
      next_q <= q; // Hold counter value when at maximum count
  end else begin
    next_q <= q; // Hold counter value when 'a' is low
  end
end

always @* begin
  if (a && (q == 3'b101)) // Reset the counter when 'a' transitions from 1 to 0
    q <= 3'b000;
  else
    q <= next_q;
end

endmodule