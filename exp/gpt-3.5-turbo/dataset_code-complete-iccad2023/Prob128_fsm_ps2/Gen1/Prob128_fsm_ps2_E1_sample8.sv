module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter VERIFY_LAST = 2'b11;

// Define signals
reg [1:0] state, next_state;

// State transition and outputs
always @(posedge clk or posedge reset) begin
  if (reset)
    state <= IDLE;
  else
    state <= next_state;

  done <= 0;
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
      next_state = BYTE2;
    end
    BYTE2: begin
      if (in[3] == 1)
        next_state = VERIFY_LAST;
      else
        next_state = IDLE;
    end
    VERIFY_LAST: begin
      if (in[3] == 1) begin
        done <= 1;
        next_state = IDLE;
      end else begin
        next_state = IDLE;
      end
    end
    default: next_state = IDLE;
  endcase
end

endmodule