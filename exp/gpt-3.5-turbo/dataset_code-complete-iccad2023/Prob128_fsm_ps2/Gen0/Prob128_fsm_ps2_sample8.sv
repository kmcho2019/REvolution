module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter CHECK_DONE = 2'b10;

// Define signals
reg [1:0] state;
reg [1:0] next_state;

// State transition and outputs
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
        next_state = BYTE1;
      else
        next_state = IDLE;
    end
    BYTE1: begin
      next_state = CHECK_DONE;
    end
    CHECK_DONE: begin
      if (in[3] == 1)
        done = 1;
      else 
        done = 0;
      next_state = IDLE;
    end
    default: next_state = IDLE;
  endcase
end

endmodule