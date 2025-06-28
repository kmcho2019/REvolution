module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states for the finite state machine
parameter START = 2'b00;
parameter RECEIVE_SECOND_BYTE = 2'b01;
parameter RECEIVE_THIRD_BYTE = 2'b10;

// State register
reg [1:0] state, next_state;

always @ (posedge clk or posedge reset)
begin
  if (reset) begin
    state <= START;
    done <= 0;
  end
  else begin
    state <= next_state;
    if (state == RECEIVE_THIRD_BYTE)
      done <= 1;
    else
      done <= 0;
  end
end

// Next state logic
always @*
begin
  next_state = state; // Default next state is current state

  case (state)
    START: begin
      if (in[3] == 1)
        next_state = RECEIVE_SECOND_BYTE;
    end
    RECEIVE_SECOND_BYTE: begin
      next_state = RECEIVE_THIRD_BYTE;
    end
    RECEIVE_THIRD_BYTE: begin
      next_state = START;
    end
  endcase
end

endmodule