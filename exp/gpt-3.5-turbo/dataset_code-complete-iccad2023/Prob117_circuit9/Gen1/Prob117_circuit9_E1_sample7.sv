module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg [2:0] q_next;

always @* begin
  q_next = q; // Initialize to current counter value by default
  if (q == 3'd4 && a == 1'b0) // Detect sequence '101' to increment counter
    q_next = q + 1;
  else if (q == 3'd6) // Reset counter to 0 when the sequence is complete
    q_next = 3'd0;
end

always @(posedge clk) begin
  q <= q_next; // Update counter value
end

endmodule