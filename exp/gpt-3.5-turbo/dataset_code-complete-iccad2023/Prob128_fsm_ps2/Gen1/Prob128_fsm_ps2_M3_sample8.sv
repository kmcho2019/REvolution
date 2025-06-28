module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

parameter IDLE = 1'b0;
parameter DONE = 1'b1;

reg state, next_state;

always @(posedge clk or posedge reset) begin
  if (reset)
    state <= IDLE;
  else
    state <= next_state;
end

always @* begin
  case(state)
    IDLE: begin
      if (in[3] == 1)
        next_state = DONE;
      else
        next_state = IDLE;
      done = 0;
    end
    DONE: begin
      next_state = IDLE;
      done = 1;
    end
    default: begin
      next_state = IDLE;
      done = 0;
    end
  endcase
end

endmodule