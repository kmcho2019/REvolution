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

  // State encoding
  typedef enum logic [2:0] {
    IDLE = 3'd0,
    SHIFT_DELAY = 3'd1,
    COUNTING = 3'd2,
    DONE_WAIT_ACK = 3'd3
  } state_t;

  state_t state, next_state;

  reg [3:0] pattern_shift;    // Shift register to detect pattern 1101
  reg [2:0] shift_cnt;        // Counts the 4 shift_ena cycles

  // Pattern to detect: 1101 binary = 4'b1101
  localparam [3:0] PATTERN = 4'b1101;

  // Update pattern_shift at every clock in IDLE state to detect pattern
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      pattern_shift <= 4'b0000;
      shift_ena <= 0;
      shift_cnt <= 0;
      counting <= 0;
      done <= 0;
    end else begin
      state <= next_state;

      case (state)
        IDLE: begin
          // Shift in new data bit
          pattern_shift <= {pattern_shift[2:0], data};
          shift_ena <= 0;
          counting <= 0;
          done <= 0;
          shift_cnt <= 0;
        end

        SHIFT_DELAY: begin
          shift_ena <= 1;
          shift_cnt <= shift_cnt + 1;
          counting <= 0;
          done <= 0;
        end

        COUNTING: begin
          shift_ena <= 0;
          counting <= 1;
          done <= 0;
        end

        DONE_WAIT_ACK: begin
          shift_ena <= 0;
          counting <= 0;
          done <= 1;
        end

        default: begin
          shift_ena <= 0;
          counting <= 0;
          done <= 0;
          shift_cnt <= 0;
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      IDLE: begin
        if (pattern_shift == PATTERN)
          next_state = SHIFT_DELAY;
      end

      SHIFT_DELAY: begin
        if (shift_cnt == 3) // After 4 cycles (0 to 3)
          next_state = COUNTING;
      end

      COUNTING: begin
        if (done_counting)
          next_state = DONE_WAIT_ACK;
      end

      DONE_WAIT_ACK: begin
        if (ack)
          next_state = IDLE;
      end
    endcase
  end

endmodule