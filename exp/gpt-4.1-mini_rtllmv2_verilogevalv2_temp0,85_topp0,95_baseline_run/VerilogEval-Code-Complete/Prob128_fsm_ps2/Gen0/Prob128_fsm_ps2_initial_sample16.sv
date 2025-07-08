module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

  // State encoding
  typedef enum reg [1:0] {
    IDLE  = 2'b00,
    BYTE2 = 2'b01,
    BYTE3 = 2'b10
  } state_t;

  state_t state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 1'b0;
    end else begin
      state <= next_state;
      // done is only asserted for one cycle after receiving byte 3
      if (state == BYTE3)
        done <= 1'b1;
      else
        done <= 1'b0;
    end
  end

  // Next state logic
  always @(*) begin
    case(state)
      IDLE: begin
        if (in[3] == 1'b1)
          next_state = BYTE2;
        else
          next_state = IDLE;
      end

      BYTE2: begin
        next_state = BYTE3;
      end

      BYTE3: begin
        // After third byte, go back to IDLE, looking for next message start
        if (in[3] == 1'b1)
          next_state = BYTE2; // The current byte could also be a start of new message
        else
          next_state = IDLE;
      end

      default: next_state = IDLE;
    endcase
  end

endmodule