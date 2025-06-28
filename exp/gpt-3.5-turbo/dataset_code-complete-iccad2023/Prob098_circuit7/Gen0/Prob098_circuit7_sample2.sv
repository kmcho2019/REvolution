module TopModule (
  input clk,
  input a,
  output reg q
);

// D flip-flop with asynchronous reset
reg q_next;

always @ (posedge clk) begin
  if (a)
    q_next <= 1'b1;
  else
    q_next <= 1'b0;
end

always @ (posedge clk or negedge a) begin
  if (!a)
    q <= 1'b0;
  else
    q <= q_next;
end

endmodule