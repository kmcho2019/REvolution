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
    COUNT = 2'd2,
    DONE = 2'd3
  } state_t;

  state_t state, next_state;

  reg [3:0] shift_reg;     // Holds last 4 bits to detect 1101
  reg [2:0] shift_count;   // Counts from 0 to 3 for 4 cycles of shift_ena

  // Sequential logic for state and shift register updates
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      shift_reg <= 4'b0000;
      shift_count <= 3'd0;
    end else begin
      state <= next_state;

      // Shift in new data bit on every clock for pattern detection only in IDLE
      if (state == IDLE) begin
        shift_reg <= {shift_reg[2:0], data};
      end

      // Increment or reset shift_count in SHIFT state
      if (state == SHIFT) begin
        shift_count <= shift_count + 1'b1;
      end else begin
        shift_count <= 3'd0;
      end
    end
  end

  // Next state logic
  always @(*) begin
    // Default outputs and next state
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    next_state = state;

    case (state)
      IDLE: begin
        // Look for pattern 1101 in shift_reg
        // If pattern detected, start SHIFT state
        if (shift_reg == 4'b1101) begin
          next_state = SHIFT;
          shift_ena = 1'b1;
        end
      end

      SHIFT: begin
        // Assert shift_ena for 4 cycles
        shift_ena = 1'b1;
        if (shift_count == 3'd3) begin
          next_state = COUNT;
        end
      end

      COUNT: begin
        // Assert counting until done_counting asserted
        counting = 1'b1;
        if (done_counting) begin
          next_state = DONE;
        end
      end

      DONE: begin
        // Assert done until ack is asserted
        done = 1'b1;
        if (ack) begin
          next_state = IDLE;
        end
      end
    endcase
  end

endmodule