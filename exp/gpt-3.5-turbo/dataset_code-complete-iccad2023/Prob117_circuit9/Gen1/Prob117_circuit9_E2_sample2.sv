module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);
  
reg [2:0] q_next;

always @* begin
  if (a && !q[2]) // Increment the counter when 'a' is high and the most significant bit is not set
    q_next = q + 1;
  else
    q_next = q;
end

always @ (posedge clk) begin
  if (a) // Update counter only when 'a' is high
    q <= q_next;
end

always @ (posedge clk) begin
  if (!a)
    q <= 3'b0; // Reset counter to 0 only when 'a' is low for consecutive clock cycles
end
  
endmodule