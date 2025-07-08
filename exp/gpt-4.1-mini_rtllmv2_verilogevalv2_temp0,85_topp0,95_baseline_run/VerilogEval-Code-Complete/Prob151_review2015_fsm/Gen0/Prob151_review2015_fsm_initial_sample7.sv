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
    IDLE = 2'd0,
    SHIFT = 2'd1,
    COUNTING = 2'd2,
    DONE = 2'd3
  } state_t;

  state_t state, next_state;

  // Shift register to detect pattern 1101
  reg [3:0] pattern_reg;

  // Counter to count 4 shift cycles
  reg [1:0] shift_count;

  // Pattern to detect
  localparam [3:0] PATTERN = 4'b1101;

  // Sequential logic: State and pattern register update
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      pattern_reg <= 4'b0000;
      shift_count <= 2'd0;
      shift_ena <= 1'b0;
      counting <= 1'b0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      // Update pattern_reg only in IDLE state to detect pattern
      if (state == IDLE) begin
        pattern_reg <= {pattern_reg[2:0], data};
      end

      // Control outputs and counters depending on state transitions and states
      case (next_state)
        IDLE: begin
          shift_ena <= 1'b0;
          counting <= 1'b0;
          done <= 1'b0;
          shift_count <= 2'd0;
        end
        SHIFT: begin
          shift_ena <= 1'b1;
          counting <= 1'b0;
          done <= 1'b0;
          // Increment shift_count on every clock in SHIFT state
          shift_count <= shift_count + 1'b1;
        end
        COUNTING: begin
          shift_ena <= 1'b0;
          counting <= 1'b1;
          done <= 1'b0;
          shift_count <= 2'd0;
        end
        DONE: begin
          shift_ena <= 1'b0;
          counting <= 1'b0;
          done <= 1'b1;
          shift_count <= 2'd0;
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case(state)
      IDLE: begin
        // Detect pattern 1101 on pattern_reg
        if (pattern_reg == PATTERN) begin
          next_state = SHIFT;
        end else begin
          next_state = IDLE;
        end
      end
      SHIFT: begin
        // After 4 shift cycles, move to COUNTING
        if (shift_count == 2'd3) begin
          next_state = COUNTING;
        end else begin
          next_state = SHIFT;
        end
      end
      COUNTING: begin
        // Wait for done_counting signal
        if (done_counting) begin
          next_state = DONE;
        end else begin
          next_state = COUNTING;
        end
      end
      DONE: begin
        // Wait for ack before returning to IDLE
        if (ack) begin
          next_state = IDLE;
        end else begin
          next_state = DONE;
        end
      end
      default: next_state = IDLE;
    endcase
  end

endmodule