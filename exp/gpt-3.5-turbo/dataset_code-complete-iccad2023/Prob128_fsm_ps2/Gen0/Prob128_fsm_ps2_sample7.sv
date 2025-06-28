module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
typedef enum logic [1:0] {
  IDLE,
  WAIT_FOR_FIRST_BYTE_WITH_IN3_HIGH,
  WAIT_FOR_SECOND_BYTE_AND_SIGNAL_DONE
} state_t;

// Define signals
reg [1:0] state, next_state;

// State transition and logic
always_ff @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
  end
  else begin
    state <= next_state;
    case(state)
      IDLE:
        if (in[3] == 1) begin
          next_state = WAIT_FOR_FIRST_BYTE_WITH_IN3_HIGH;
        end
        else begin
          next_state = IDLE;
        end
      WAIT_FOR_FIRST_BYTE_WITH_IN3_HIGH:
        if (in[3] == 1) begin
          next_state = WAIT_FOR_SECOND_BYTE_AND_SIGNAL_DONE;
        end
        else begin
          next_state = WAIT_FOR_FIRST_BYTE_WITH_IN3_HIGH;
        end
      WAIT_FOR_SECOND_BYTE_AND_SIGNAL_DONE:
        next_state = IDLE;
    endcase
  end
end

// Output logic
always_comb begin
  done = (state == WAIT_FOR_SECOND_BYTE_AND_SIGNAL_DONE);
end

endmodule