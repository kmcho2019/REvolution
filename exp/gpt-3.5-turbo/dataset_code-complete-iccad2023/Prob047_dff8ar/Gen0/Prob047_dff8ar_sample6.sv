module TopModule (
  input clk,
  input [7:0] d,
  input areset,
  output reg [7:0] q
);

reg [7:0] q_reg;

always @(posedge clk) begin
  if (areset) begin
    q_reg <= 8'b0; // Reset the output to 0
  end else begin
    q_reg <= d;
  end
end

assign q = q_reg;

endmodule