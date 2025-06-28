module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

reg [1:0] state;
parameter IDLE = 2'b00;
parameter CONVERT = 2'b01;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= IDLE;
    z <= 1'b0;
  end
  else begin
    case(state)
      IDLE: begin
        if (x == 1'b0)
          state <= IDLE;
        else
          state <= CONVERT;
      end
      CONVERT: begin
        z <= ~z; // toggle z on every CONVERT state entry
        if (x == 1'b0)
          state <= IDLE;
        else
          state <= CONVERT;
      end
      default: state <= IDLE;
    endcase
  end
end

endmodule