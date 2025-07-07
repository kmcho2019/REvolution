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
  typedef enum logic [1:0] {
    IDLE = 2'b00,
    SHIFT = 2'b01,
    COUNT = 2'b10,
    DONE = 2'b11
  } state_t;

  state_t state, next_state;

  // Shift register to detect pattern 1101
  reg [3:0] pattern_shift;

  // Counter for 4 shift cycles
  reg [1:0] shift_count;

  // Pattern to detect
  localparam [3:0] PATTERN = 4'b1101;

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      pattern_shift <= 4'b0;
      shift_count <= 2'b0;
      shift_ena <= 1'b0;
      counting <= 1'b0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      // Shift in data for pattern detection only in IDLE
      if (state == IDLE) begin
        pattern_shift <= {pattern_shift[2:0], data};
      end

      // Manage shift_count in SHIFT state
      if (state == SHIFT) begin
        shift_count <= shift_count + 1;
      end else begin
        shift_count <= 2'b0;
      end

      // Outputs controlled by state
      case (next_state)
        IDLE: begin
          shift_ena <= 1'b0;
          counting <= 1'b0;
          done <= 1'b0;
        end
        SHIFT: begin
          shift_ena <= 1'b1;
          counting <= 1'b0;
          done <= 1'b0;
        end
        COUNT: begin
          shift_ena <= 1'b0;
          counting <= 1'b1;
          done <= 1'b0;
        end
        DONE: begin
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
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      IDLE: begin
        if (pattern_shift == PATTERN)
          next_state = SHIFT;
        else
          next_state = IDLE;
      end
      SHIFT: begin
        if (shift_count == 2'd3) // after 4 cycles (0..3)
          next_state = COUNT;
        else
          next_state = SHIFT;
      end
      COUNT: begin
        if (done_counting)
          next_state = DONE;
        else
          next_state = COUNT;
      end
      DONE: begin
        if (ack)
          next_state = IDLE;
        else
          next_state = DONE;
      end
      default: next_state = IDLE;
    endcase
  end

endmodule