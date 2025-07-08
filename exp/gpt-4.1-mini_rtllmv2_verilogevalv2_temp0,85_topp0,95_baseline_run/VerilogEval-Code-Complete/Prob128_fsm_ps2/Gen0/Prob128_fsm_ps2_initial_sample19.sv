module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

  typedef enum logic [1:0] {
    IDLE = 2'b00,
    BYTE1 = 2'b01,
    BYTE2 = 2'b10,
    BYTE3 = 2'b11
  } state_t;

  state_t state, next_state;

  // FSM state transitions
  always_ff @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 1'b0;
    end else begin
      state <= next_state;
      // done asserted only for one cycle immediately after 3rd byte
      done <= (state == BYTE3);
    end
  end

  always_comb begin
    next_state = state;
    case (state)
      IDLE: begin
        // Wait for byte with in[3] == 1 to start message
        if (in[3] == 1'b1)
          next_state = BYTE1;
      end
      BYTE1: begin
        // After first byte, go to second byte
        next_state = BYTE2;
      end
      BYTE2: begin
        // After second byte, go to third byte
        next_state = BYTE3;
      end
      BYTE3: begin
        // After third byte and done asserted, go back to IDLE to find next message start
        next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

endmodule