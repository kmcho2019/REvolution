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
reg [2:0] count;

always @(posedge clk or posedge reset)
begin
  if (reset)
  begin
    state <= IDLE;
    count <= 3'b0;
  end
  else
  begin
    state <= next_state;
    count <= (state == D4) ? 3'b0 : count + 3'b1;
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
    D1, D2, D3:
      begin
        shift_ena = 1;
        next_state = (state == D3) ? D4 : state + 1;
      end
    D4:
      begin
        shift_ena = 1;
        next_state = WAIT;
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