module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_ff;
reg q_previous;

always @(posedge clk or negedge clk) begin
  if (~clk) begin // Detect falling edge
    q_ff <= q_previous; // Capture the previous value at falling edge
  end
  else begin // Detect rising edge
    q_ff <= d; // Store the input value at rising edge
  end
end

always @* begin
  q_previous = q_ff; // Store the current flip-flop value in q_previous
  q = q_previous; // Assign q to the stored value
end

endmodule