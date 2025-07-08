module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

  typedef enum logic [1:0] {
    IDLE = 2'd0,
    BYTE2 = 2'd1,
    BYTE3 = 2'd2
  } state_t;

  state_t state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 1'b0;
    end else begin
      state <= next_state;
      // done is asserted only on transition from BYTE3 on valid byte
      if (state == BYTE3)
        done <= 1'b1;
      else
        done <= 1'b0;
    end
  end

  always @(*) begin
    next_state = state;
    case(state)
      IDLE: begin
        if (in[3] == 1'b1)
          next_state = BYTE2; // first byte found
      end
      BYTE2: begin
        next_state = BYTE3; // second byte received
      end
      BYTE3: begin
        // After done asserted, next state depends on in[3]
        if (in[3] == 1'b1)
          next_state = BYTE2; // start new message
        else
          next_state = IDLE; // invalid start, resync
      end
      default: next_state = IDLE;
    endcase
  end

endmodule