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
  D1,
  D2,
  D3,
  D4,
  WAIT,
  DONE
} state_t;

// State register
reg [2:0] state, next_state;
reg [2:0] shift_counter;

always @(posedge clk or posedge reset)
begin
  if (reset)
  begin
    state <= IDLE;
    shift_counter <= 0;
  end
  else
  begin
    state <= next_state;
    shift_counter <= (state == D4) ? (shift_counter + 1) : 0;
  end
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
          next_state = D1;
        else
          next_state = IDLE;
      end
    D1:
      begin
        shift_ena = 1;
        next_state = D2;
      end
    D2:
      begin
        shift_ena = 1;
        next_state = D3;
      end
    D3:
      begin
        shift_ena = 1;
        next_state = D4;
      end
    D4:
      begin
        if (shift_counter == 4)
          next_state = WAIT;
        else
          next_state = D4;
      end
    WAIT:
      begin
        counting = 1;
        if (done_counting)
          next_state = DONE;
        else
          next_state = WAIT;
      end
    DONE:
      begin
        done = 1;
        if (ack)
          next_state = IDLE;
        else
          next_state = DONE;
      end
  endcase
end

endmodule