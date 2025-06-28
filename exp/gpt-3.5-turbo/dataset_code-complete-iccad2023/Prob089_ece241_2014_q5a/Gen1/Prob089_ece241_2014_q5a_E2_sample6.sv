module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

reg [1:0] state;
parameter IDLE = 2'b00;
parameter CONVERT = 2'b01;
reg x_reg, x_dly;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= IDLE;
    z <= 1'b0;
  end
  else begin
    state <= (state == IDLE && !areset) ? (x == 1'b1 ? CONVERT : IDLE) : (state == CONVERT ? IDLE : CONVERT);
  end
end

always @(posedge clk) begin
  x_reg <= x;
  x_dly <= x_reg;
  z <= (state == CONVERT) ? ~z : z;
end

endmodule