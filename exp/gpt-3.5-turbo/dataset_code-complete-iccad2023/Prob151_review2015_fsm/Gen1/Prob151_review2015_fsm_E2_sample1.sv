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
  parameter IDLE = 3'b000, PATTERN_DETECT = 3'b001, SHIFT_ENA = 3'b010, 
            WAIT_FOR_COUNTERS = 3'b011, TIMED_OUT = 3'b100, WAIT_FOR_ACK = 3'b101;
  
  // State register
  reg [2:0] state, next_state;

  // State transition and outputs assignment
  always @* begin
    case (state)
      IDLE: begin
        shift_ena = 0;
        counting = 0;
        if (data == 4'b1101) begin
          next_state = PATTERN_DETECT;
        end else begin
          next_state = IDLE;
        end
      end

      PATTERN_DETECT: begin
        shift_ena = 1;
        if (count == 4) begin
          next_state = SHIFT_ENA;
        end else begin
          next_state = PATTERN_DETECT;
        end
      end
      
      SHIFT_ENA: begin
        shift_ena = 0;
        counting = 1;
        if (done_counting) begin
          next_state = WAIT_FOR_COUNTERS;
        end else begin
          next_state = SHIFT_ENA;
        end
      end
      
      WAIT_FOR_COUNTERS: begin
        shift_ena = 0;
        counting = 0;
        if (done_counting) begin
          next_state = TIMED_OUT;
        end else begin
          next_state = WAIT_FOR_COUNTERS;
        end
      end
      
      TIMED_OUT: begin
        done = 1;
        if (ack) begin
          next_state = IDLE;
        end else begin
          next_state = TIMED_OUT;
        end
      end
      
    endcase
  end

  // State transition on clock edge
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end
  
endmodule