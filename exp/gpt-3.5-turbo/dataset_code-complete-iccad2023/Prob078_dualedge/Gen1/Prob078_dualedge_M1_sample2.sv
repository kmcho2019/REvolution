module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_ff;

always @(posedge clk or negedge clk) begin
  if (~$past(clk)) begin
    q_ff <= d; // Capture input on falling edge
  end else begin
    q_ff <= q_ff; // Hold the value on rising edge
  end
end

assign q = q_ff;

endmodule