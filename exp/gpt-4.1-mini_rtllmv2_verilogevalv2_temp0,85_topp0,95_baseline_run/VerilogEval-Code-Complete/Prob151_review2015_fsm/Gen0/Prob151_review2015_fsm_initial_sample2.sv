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
  typedef enum reg [2:0] {
    SEARCH = 3'd0,
    SHIFT  = 3'd1,
    COUNT  = 3'd2,
    DONE   = 3'd3,
    WAIT_ACK = 3'd4
  } state_t;

  reg [2:0] state, next_state;

  // Shift register to detect pattern 1101
  reg [3:0] pattern_shift;

  // Counter for shift cycles (4 cycles)
  reg [2:0] shift_count;

  // Pattern to detect
  localparam [3:0] PATTERN = 4'b1101;

  // State transition logic and outputs
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      pattern_shift <= 4'd0;
      shift_count <= 3'd0;
      shift_ena <= 1'b0;
      counting <= 1'b0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      case (state)
        SEARCH: begin
          shift_ena <= 1'b0;
          counting <= 1'b0;
          done <= 1'b0;

          // Shift in data to pattern_shift
          pattern_shift <= {pattern_shift[2:0], data};
        end

        SHIFT: begin
          shift_ena <= 1'b1;
          counting <= 1'b0;
          done <= 1'b0;
          // Keep shifting in data (pattern_shift can also be updated but not required)
          pattern_shift <= {pattern_shift[2:0], data};
          // shift_count updated below
        end

        COUNT: begin
          shift_ena <= 1'b0;
          counting <= 1'b1;
          done <= 1'b0;
          // pattern_shift not updated here
        end

        DONE: begin
          shift_ena <= 1'b0;
          counting <= 1'b0;
          done <= 1'b1;
        end

        WAIT_ACK: begin
          shift_ena <= 1'b0;
          counting <= 1'b0;
          done <= 1'b1;
        end

        default: begin
          shift_ena <= 1'b0;
          counting <= 1'b0;
          done <= 1'b0;
        end
      endcase

      // Shift counter increment/decrement logic only valid in SHIFT state
      if (state == SHIFT) begin
        shift_count <= shift_count + 3'd1;
      end else begin
        shift_count <= 3'd0;
      end
    end
  end

  // Next state logic combinational
  always @(*) begin
    next_state = state;
    case (state)
      SEARCH: begin
        // Detect pattern 1101
        if (pattern_shift == PATTERN)
          next_state = SHIFT;
      end

      SHIFT: begin
        // After 4 shift cycles, go to counting state
        if (shift_count == 3'd4)
          next_state = COUNT;
      end

      COUNT: begin
        // Wait for done_counting input
        if (done_counting)
          next_state = DONE;
      end

      DONE: begin
        // Move to wait_ack state
        next_state = WAIT_ACK;
      end

      WAIT_ACK: begin
        // Wait for ack input, then go back to search
        if (ack)
          next_state = SEARCH;
      end

      default: next_state = SEARCH;
    endcase
  end

endmodule