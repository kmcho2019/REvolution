module Complementer (
  input clk,
  input areset,
  input x,
  output reg z
);

// State definitions
parameter IDLE = 2'b00;
parameter CONVERT = 2'b01;
parameter DONE = 2'b10;

reg [1:0] state, next_state;
reg carry_in;

always @ (posedge clk or negedge areset)
begin
  if (~areset)
    state <= IDLE;
  else
    state <= next_state;
end

always @ *
begin
  case (state)
    IDLE:
    begin
      if (areset == 1'b0)
        next_state = CONVERT;
      else
        next_state = IDLE;
    end
    CONVERT:
    begin
      next_state = (x ^ carry_in) ? CONVERT : DONE;
      carry_in = carry_in & x;
    end
    DONE:
    begin
      if (areset == 1'b1)
        next_state = IDLE;
      else
        next_state = DONE;
    end
  endcase
end

always @ (posedge clk)
begin
  case (state)
    CONVERT:
    begin
      z <= ~x + 1;
    end
    default:
    begin
      z <= 1'b0;
    end
  endcase
end

endmodule