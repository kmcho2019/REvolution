module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

  typedef enum logic [1:0] {IDLE, BYTE2, BYTE3} state_t;
  state_t state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 0;
    end else begin
      state <= next_state;
      // done is asserted only one cycle after third byte received
      if (state == BYTE3)
        done <= 1;
      else
        done <= 0;
    end
  end

  always @(*) begin
    // Default next state is current state
    next_state = state;
    case(state)
      IDLE: begin
        // wait for first byte with in[3] = 1
        if (in[3] == 1)
          next_state = BYTE2;
      end
      BYTE2: begin
        // accept second byte (no condition)
        next_state = BYTE3;
      end
      BYTE3: begin
        // accept third byte and then return to IDLE
        next_state = IDLE;
      end
    endcase
  end

endmodule