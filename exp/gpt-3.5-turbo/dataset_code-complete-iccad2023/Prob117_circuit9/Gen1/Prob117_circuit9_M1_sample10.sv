module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg [2:0] q_next;

always @(*) begin
  q_next = q; // Keep the current value of q by default
  if (a && (clk ^ 1)) begin // Increment counter if a is high and clk transitions from 0 to 1
    if (q < 3'd6) // Counter should increment from 0 to 6
      q_next = q + 1;
  end else if (!a) begin // Reset counter if a transitions from high to low
    q_next = 3'b0;
  end
end

always @ (posedge clk)
  q <= q_next;

endmodule