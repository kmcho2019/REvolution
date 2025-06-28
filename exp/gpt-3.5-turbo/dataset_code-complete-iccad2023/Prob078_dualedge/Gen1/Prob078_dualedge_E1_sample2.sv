module TopModule (
  input clk,
  input d,
  output reg q
);

reg d_sync_pos, d_sync_neg;
reg q_ff;

always @(posedge clk) begin
  d_sync_pos <= d;
end

always @(negedge clk) begin
  d_sync_neg <= d_sync_pos;
end

always @(posedge clk or negedge clk) begin
  q_ff <= (clk & ~d_sync_neg) | (~clk & d_sync_pos); // Detect transitions on both clock edges
end

assign q = q_ff;

endmodule