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

  // States encoding
  typedef enum reg [1:0] {
    SEARCH = 2'b00,
    SHIFT = 2'b01,
    COUNTING = 2'b10,
    DONE = 2'b11
  } state_t;

  reg [1:0] state, next_state;

  reg [3:0] pattern_shift_reg;  // to detect 1101 pattern
  reg [2:0] shift_counter;      // to count 4 cycles of shift_ena

  // Pattern to detect: 1101 = 4'b1101
  localparam [3:0] START_PATTERN = 4'b1101;

  // Sequential logic: state and shift registers update
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      pattern_shift_reg <= 4'b0000;
      shift_counter <= 3'd0;
    end else begin
      state <= next_state;

      if (state == SEARCH) begin
        // Shift in data for pattern detection
        pattern_shift_reg <= {pattern_shift_reg[2:0], data};
      end else if (state == SHIFT) begin
        // Count shift cycles
        shift_counter <= shift_counter + 1;
      end else begin
        shift_counter <= 3'd0; // reset counter outside SHIFT
      end
    end
  end

  // Next state logic
  always @(*) begin
    // Defaults
    next_state = state;

    case(state)
      SEARCH: begin
        if (pattern_shift_reg == START_PATTERN)
          next_state = SHIFT;
      end
      SHIFT: begin
        if (shift_counter == 3'd3) // after 4 cycles (0,1,2,3)
          next_state = COUNTING;
      end
      COUNTING: begin
        if (done_counting)
          next_state = DONE;
      end
      DONE: begin
        if (ack)
          next_state = SEARCH;
      end
    endcase
  end

  // Output logic (registered outputs)
  always @(posedge clk) begin
    if (reset) begin
      shift_ena <= 1'b0;
      counting <= 1'b0;
      done <= 1'b0;
    end else begin
      case(state)
        SEARCH: begin
          shift_ena <= 1'b0;
          counting <= 1'b0;
          done <= 1'b0;
        end
        SHIFT: begin
          shift_ena <= 1'b1;
          counting <= 1'b0;
          done <= 1'b0;
        end
        COUNTING: begin
          shift_ena <= 1'b0;
          counting <= 1'b1;
          done <= 1'b0;
        end
        DONE: begin
          shift_ena <= 1'b0;
          counting <= 1'b0;
          done <= 1'b1;
        end
      endcase
    end
  end

endmodule