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
  parameter DETECT_PATTERN = 3'b000, SHIFT_IN = 3'b001, WAITING_COUNTERS = 3'b010, TIMED_OUT_NOTIFY = 3'b011, ACKNOWLEDGE_WAIT = 3'b100;

  // Define state register
  reg [2:0] state, next_state;

  // State register always block
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= DETECT_PATTERN;
    end else begin
      state <= next_state;
    end
  end

  // Combinational logic to determine next state and control outputs
  always @* begin
    shift_ena = 0;
    counting = 0;
    done = 0;
    
    // Default next state
    next_state = state;

    case (state)
      DETECT_PATTERN: begin
        if (data == 4'b1101) begin
          next_state = SHIFT_IN;
        end
      end

      SHIFT_IN: begin
        shift_ena = 1;
        next_state = WAITING_COUNTERS;
      end

      WAITING_COUNTERS: begin
        counting = 1;
        if (done_counting) begin
          next_state = TIMED_OUT_NOTIFY;
        end 
      end

      TIMED_OUT_NOTIFY: begin
        done = 1;
        next_state = ACKNOWLEDGE_WAIT;
      end

      ACKNOWLEDGE_WAIT: begin
        if (ack) begin
          next_state = DETECT_PATTERN; // Reset to detect the start pattern again
        end
      end
    endcase
  end

endmodule