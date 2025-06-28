module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_ff;

always @(posedge clk or negedge clk) begin
  q_ff <= d ^ q_ff;
end

assign q = q_ff;

endmodule