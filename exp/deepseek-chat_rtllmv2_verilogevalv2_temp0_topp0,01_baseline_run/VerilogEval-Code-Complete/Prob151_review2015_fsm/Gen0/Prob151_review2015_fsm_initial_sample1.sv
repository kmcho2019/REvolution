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
  typedef enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
  } state_t;

  state_t current_state, next_state;

  // Pattern detection registers
  reg [3:0] pattern_reg;
  reg [1:0] shift_count;

  // State transition and output logic
  always_ff @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      pattern_reg <= 4'b0;
      shift_count <= 2'b0;
    end else begin
      current_state <= next_state;
      
      // Shift in data for pattern detection
      pattern_reg <= {pattern_reg[2:0], data};
      
      // Count shift cycles
      if (current_state == SHIFT) begin
        shift_count <= shift_count + 1;
      end else begin
        shift_count <= 2'b0;
      end
    end
  end

  // Next state logic
  always_comb begin
    case (current_state)
      IDLE: begin
        if (pattern_reg == 4'b1101) begin
          next_state = SHIFT;
        end else begin
          next_state = IDLE;
        end
      end
      
      SHIFT: begin
        if (shift_count == 2'b11) begin  // After 4 cycles (0-3)
          next_state = COUNT;
        end else begin
          next_state = SHIFT;
        end
      end
      
      COUNT: begin
        if (done_counting) begin
          next_state = DONE;
        end else begin
          next_state = COUNT;
        end
      end
      
      DONE: begin
        if (ack) begin
          next_state = IDLE;
        end else begin
          next_state = DONE;
        end
      end
      
      default: next_state = IDLE;
    endcase
  end

  // Output logic
  always_comb begin
    shift_ena = (current_state == SHIFT);
    counting = (current_state == COUNT);
    done = (current_state == DONE);
  end

endmodule