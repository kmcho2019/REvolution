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
  typedef enum reg [1:0] {
    IDLE = 2'b00,
    SHIFT = 2'b01,
    COUNT = 2'b10,
    DONE = 2'b11
  } state_t;
  
  reg [1:0] state, next_state;
  
  reg [3:0] pattern_shiftreg;
  reg [2:0] shift_counter; // counts 4 cycles for shift_ena

  // Sequential state and shift register update
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      pattern_shiftreg <= 4'b0000;
      shift_counter <= 3'd0;
    end else begin
      state <= next_state;
      // Shift in new data only in IDLE state to detect pattern
      if (state == IDLE) begin
        pattern_shiftreg <= {pattern_shiftreg[2:0], data};
      end
      // Count shift cycles in SHIFT state
      if (state == SHIFT) begin
        shift_counter <= shift_counter + 3'd1;
      end else begin
        shift_counter <= 3'd0;
      end
    end
  end

  // Next state logic
  always @(*) begin
    // Default outputs low
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    next_state = state;

    case(state)
      IDLE: begin
        // Detect pattern 1101 in the 4-bit shift register
        if (pattern_shiftreg == 4'b1101) begin
          next_state = SHIFT;
        end
      end
      SHIFT: begin
        shift_ena = 1'b1;
        if (shift_counter == 3'd3) begin // after 4 cycles (counting from 0)
          next_state = COUNT;
        end
      end
      COUNT: begin
        counting = 1'b1;
        if (done_counting) begin
          next_state = DONE;
        end
      end
      DONE: begin
        done = 1'b1;
        if (ack) begin
          next_state = IDLE;
        end
      end
    endcase
  end

endmodule