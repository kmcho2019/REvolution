module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
parameter IDLE = 3'b000;
parameter START_BYTE = 3'b001;
parameter SECOND_BYTE = 3'b010;
parameter THIRD_BYTE = 3'b011;
parameter DONE = 3'b100;

// Define signals
reg [2:0] state, next_state;

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
        next_state = START_BYTE;
      else
        next_state = IDLE;
    end
    START_BYTE: begin
      next_state = SECOND_BYTE;
    end
    SECOND_BYTE: begin
      next_state = THIRD_BYTE;
    end
    THIRD_BYTE: begin
      if (in[3] == 1)
        next_state = DONE;
      else
        next_state = IDLE;
    end
    DONE: begin
      next_state = IDLE;
      done = 1;
    end
    default: next_state = IDLE;
  endcase
end

endmodule