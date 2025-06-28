module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
parameter IDLE = 2'b00;
parameter FIRST_BYTE = 2'b01;
parameter SECOND_BYTE = 2'b10;
parameter DONE = 2'b11;

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
        next_state = FIRST_BYTE;
      else
        next_state = IDLE;
    end
    FIRST_BYTE: begin
      next_state = SECOND_BYTE;
    end
    SECOND_BYTE: begin
      if (in[3] == 1)
        next_state = DONE;
      else
        next_state = IDLE;
    end
    DONE: begin
      done = 1;
      next_state = IDLE;
    end
    default: next_state = IDLE;
  endcase
end

endmodule