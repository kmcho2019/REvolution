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

  // Define states
  typedef enum logic [2:0] {
    S_IDLE = 3'd0,          // Searching for pattern 1101
    S_SHIFT = 3'd1,         // Shifting in 4 bits
    S_COUNTING = 3'd2,      // Waiting for counters to finish
    S_DONE = 3'd3           // Timer done, waiting for ack
  } state_t;

  state_t state, next_state;

  // To detect pattern 1101, we keep a 4-bit shift register of recent bits
  reg [3:0] shift_reg;

  // Counter for shift_ena assertion cycles
  reg [2:0] shift_count; // enough for 4 counts

  // State register and combinational next state logic
  always @(posedge clk) begin
    if (reset) begin
      state <= S_IDLE;
      shift_reg <= 4'd0;
      shift_ena <= 0;
      counting <= 0;
      done <= 0;
      shift_count <= 3'd0;
    end else begin
      state <= next_state;

      case (state)
        S_IDLE: begin
          done <= 0;
          counting <= 0;
          shift_ena <= 0;
          // Shift in new data bit
          shift_reg <= {shift_reg[2:0], data};
          shift_count <= 0;
        end

        S_SHIFT: begin
          done <= 0;
          counting <= 0;
          shift_ena <= 1;
          // Shift in data as well to keep track (optional)
          shift_reg <= {shift_reg[2:0], data};
          shift_count <= shift_count + 1;
        end

        S_COUNTING: begin
          done <= 0;
          counting <= 1;
          shift_ena <= 0;
          shift_count <= 0;
          // shift_reg unchanged
        end

        S_DONE: begin
          done <= 1;
          counting <= 0;
          shift_ena <= 0;
          shift_count <= 0;
          // shift_reg unchanged
        end

        default: begin
          // default safe values
          done <= 0;
          counting <= 0;
          shift_ena <= 0;
          shift_count <= 0;
        end
      endcase
    end
  end

  // Next state combinational logic
  always @(*) begin
    next_state = state;

    case (state)
      S_IDLE: begin
        // Check if pattern 1101 detected in shift_reg
        // Pattern bits: 1 1 0 1 (MSB to LSB)
        // shift_reg[3:0]
        if (shift_reg == 4'b1101) begin
          next_state = S_SHIFT;
        end else begin
          next_state = S_IDLE;
        end
      end

      S_SHIFT: begin
        if (shift_count == 3'd3) begin
          // After 4 cycles (0,1,2,3)
          next_state = S_COUNTING;
        end else begin
          next_state = S_SHIFT;
        end
      end

      S_COUNTING: begin
        if (done_counting) begin
          next_state = S_DONE;
        end else begin
          next_state = S_COUNTING;
        end
      end

      S_DONE: begin
        if (ack) begin
          next_state = S_IDLE;
        end else begin
          next_state = S_DONE;
        end
      end

      default: next_state = S_IDLE;
    endcase
  end

endmodule