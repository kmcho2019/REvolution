module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_ff;
reg q_temp;

always @(posedge clk or negedge clk) begin
  if (~clk) begin // Detect rising edge
    q_temp <= d;
  end
end

always @(posedge clk or negedge clk) begin
  if (clk) begin // Detect falling edge
    q_ff <= q_temp;
  end
end

assign q = q_ff;

endmodule