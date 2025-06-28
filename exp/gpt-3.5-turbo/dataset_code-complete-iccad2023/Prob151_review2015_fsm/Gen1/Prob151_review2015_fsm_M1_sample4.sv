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
    COUNTING = 3'b011, DONE_WAIT = 3'b100, DONE_ACK_WAIT = 3'b101;
  
  reg [2:0] state, next_state;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end
    else begin
      state <= next_state;
    end
  end
  
  always @* begin
    // Default assignments
    next_state = state;
    shift_ena = 0;
    counting = 0;
    done = 0;
    
    // State transitions and output assignments
    case (state)
      IDLE: begin
        if (data == 3'b110) begin
          next_state = PATTERN_DETECT;
        end
      end
      PATTERN_DETECT: begin
        if (data == 3'b1101) begin
          next_state = SHIFT_ENA;
        end
        else begin
          next_state = IDLE;
        end
      end
      SHIFT_ENA: begin
        shift_ena = 1;
        next_state = COUNTING;
      end
      COUNTING: begin
        if (done_counting) begin
          next_state = DONE_WAIT;
        end
      end
      DONE_WAIT: begin
        done = 1;
        if (ack) begin
          next_state = DONE_ACK_WAIT;
        end
      end
      DONE_ACK_WAIT: begin
        if (~ack) begin
          next_state = IDLE;
        end
      end
    endcase
  end

endmodule