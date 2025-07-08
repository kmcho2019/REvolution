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

  state_t state, next_state;

  reg [3:0] shift_reg;       // to detect pattern 1101
  reg [2:0] shift_count;     // counts up to 4 cycles during SHIFT

  // Pattern to detect: 1101
  localparam [3:0] PATTERN = 4'b1101;

  // Sequential logic: state and shift register updates
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      shift_reg <= 4'b0000;
      shift_count <= 3'b000;
    end else begin
      state <= next_state;

      // Shift in data only in IDLE or SHIFT states
      if (state == IDLE) begin
        shift_reg <= {shift_reg[2:0], data};
      end else if (state == SHIFT) begin
        // Count the 4 shift cycles
        shift_count <= shift_count + 1;
      end else begin
        // reset shift_count and shift_reg when not shifting or searching
        shift_count <= 3'b000;
        shift_reg <= 4'b0000;
      end
    end
  end

  // Next state logic and output assignment
  always @(*) begin
    // Default outputs
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    next_state = state;

    case(state)
      IDLE: begin
        // Check if pattern detected
        if (shift_reg == PATTERN) begin
          next_state = SHIFT;
          shift_ena = 1'b1; // first cycle of shift
        end
      end
      SHIFT: begin
        // Assert shift_ena for exactly 4 cycles
        shift_ena = 1'b1;
        if (shift_count == 3'd3) begin
          // completed 4 cycles (count from 0 to 3)
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