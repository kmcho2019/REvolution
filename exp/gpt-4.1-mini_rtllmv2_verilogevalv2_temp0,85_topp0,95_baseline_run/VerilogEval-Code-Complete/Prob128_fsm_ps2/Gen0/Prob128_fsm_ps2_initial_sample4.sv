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
      // done is asserted only in transition from BYTE3 to IDLE
      done <= (state == BYTE3);
    end
  end

  always @(*) begin
    // Default next_state is current state
    next_state = state;
    case (state)
      IDLE: begin
        if (in[3]) begin
          next_state = BYTE2;
        end
      end
      BYTE2: begin
        next_state = BYTE3;
      end
      BYTE3: begin
        // After third byte, go back to IDLE to look for next message
        next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

endmodule