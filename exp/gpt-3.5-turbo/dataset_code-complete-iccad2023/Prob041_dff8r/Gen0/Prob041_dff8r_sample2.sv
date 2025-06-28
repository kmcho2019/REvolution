module TopModule (
  input clk,
  input [7:0] d,
  input reset,
  output reg [7:0] q
);

reg [7:0] d_reg;
reg [7:0] q_reg;
reg reset_reg;

always @(posedge clk) begin
  if (reset_reg) begin
    q_reg <= 8'b0;
  end else begin
    q_reg <= d_reg;
  end
end

always @(posedge clk) begin
  d_reg <= d;
  reset_reg <= reset;
end

assign q = q_reg;

endmodule