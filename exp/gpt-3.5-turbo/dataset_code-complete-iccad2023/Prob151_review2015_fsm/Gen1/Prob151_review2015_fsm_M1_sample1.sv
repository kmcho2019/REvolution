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
  
  // Define states for the state machine
  typedef enum logic [3:0] {
    IDLE,
    DETECT_PATTERN,
    SHIFT_IN_BITS,
    WAITING_FOR_COUNTERS,
    NOTIFY_USER,
    WAIT_FOR_ACK
  } state_type;
  
  // Define registers for state machine
  reg [3:0] state, next_state;
  reg [3:0] bit_counter;

  // State machine logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      bit_counter <= 4'b0;
    end else begin
      state <= next_state;
    end
  end

  // Default next state (no state change)
  always @* begin
    next_state = state;
    shift_ena = 0;
    counting = 0;
    done = 0;
    
    // State transitions and outputs
    case (state)
      IDLE: begin
        if (data == 4'b1101) begin
          next_state = DETECT_PATTERN;
        end
      end

      DETECT_PATTERN: begin
        // Reset bit counter
        bit_counter <= 0;
        shift_ena = 1;
        next_state = SHIFT_IN_BITS;
      end

      SHIFT_IN_BITS: begin
        // Shift in 4 more bits
        if (bit_counter < 4) begin
          bit_counter <= bit_counter + 1;
        end else begin
          counting = 1;
          next_state = WAITING_FOR_COUNTERS;
        end
      end

      WAITING_FOR_COUNTERS: begin
        if (done_counting) begin
          next_state = NOTIFY_USER;
        end
      end
      
      NOTIFY_USER: begin
        done = 1;
        next_state = WAIT_FOR_ACK;
      end
      
      WAIT_FOR_ACK: begin
        if (ack) begin
          next_state = IDLE;
        end
      end
      
      default: next_state = IDLE;
    endcase
  end
endmodule