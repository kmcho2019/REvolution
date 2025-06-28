module TopModule (
  input clk,
  input reset,
  input data,
  output reg shift_ena,
  output reg counting,
  input done_counting,
  output reg done,
  input ack
);

// Enum for states
typedef enum logic [2:0] {
  IDLE,
  DETECT_PATTERN,
  PROCESS_DATA,
  WAIT_FOR_ACK
} state_t;

// State register
reg [2:0] state, next_state;

always @(posedge clk or posedge reset)
begin
  if (reset)
    state <= IDLE;
  else
    state <= next_state;
end

always @*
begin
  shift_ena = 0;
  counting = 0;
  done = 0;
  
  case(state)
    IDLE:
      begin
        if (data == 4'b1101)
          next_state = PROCESS_DATA;
        else
          next_state = IDLE;
      end
    PROCESS_DATA:
      begin
        shift_ena = 1;
        if (shift_ena)
          next_state = WAIT_FOR_ACK;
      end
    WAIT_FOR_ACK:
      begin
        counting = 1;
        if (done_counting) begin
          done = 1;
          if (ack)
            next_state = IDLE;
        end
      end
  endcase
end

endmodule