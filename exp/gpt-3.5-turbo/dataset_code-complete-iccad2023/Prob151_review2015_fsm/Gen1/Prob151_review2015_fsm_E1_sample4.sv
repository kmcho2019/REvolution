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
  parameter WAIT_FOR_PATTERN = 3'b000, 
            PATTERN_DETECTED = 3'b001, 
            SHIFT_ENA_ACTIVE = 3'b010, 
            COUNTING_WAIT = 3'b011, 
            ACK_WAIT = 3'b100;
  
  // State register
  reg [2:0] state, next_state;
  
  // State transition and control logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= WAIT_FOR_PATTERN;
    end else begin
      state <= next_state;
    end
  end
  
  always @* begin
    next_state = state;
    
    case (state)
      WAIT_FOR_PATTERN: begin
        if (data == 4'b1101) begin
          next_state = PATTERN_DETECTED;
        end
      end
      PATTERN_DETECTED: begin
        next_state = SHIFT_ENA_ACTIVE;
      end
      SHIFT_ENA_ACTIVE: begin
        if (counting == 4) begin
          next_state = COUNTING_WAIT;
        end
      end
      COUNTING_WAIT: begin
        if (done_counting) begin
          next_state = ACK_WAIT;
        end
      end
      ACK_WAIT: begin
        if (ack) begin
          next_state = WAIT_FOR_PATTERN;
        end
      end
    endcase
  end
  
  // Output control based on state
  always @* begin
    shift_ena = (state == SHIFT_ENA_ACTIVE) ? 1'b1 : 1'b0;
    counting = (state == COUNTING_WAIT) ? 1'b1 : 1'b0;
    done = (state == ACK_WAIT) ? 1'b1 : 1'b0;
  end

endmodule