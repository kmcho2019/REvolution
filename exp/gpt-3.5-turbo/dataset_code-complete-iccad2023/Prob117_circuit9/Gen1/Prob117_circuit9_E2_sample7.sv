module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg [2:0] q_next;

always @* begin
  q_next = q;
  
  if (a == 1) begin
    q_next = (q == 3'd6) ? 3'b0 : q + 1;
  end else begin
    q_next = q; // Retain current value if 'a' is low
  end
  
  if (a == 0) begin
    q_next = 3'b0; // Reset counter to 0 when 'a' transitions from high to low
  end
end

always @ (posedge clk) begin
  q <= q_next;
end

endmodule