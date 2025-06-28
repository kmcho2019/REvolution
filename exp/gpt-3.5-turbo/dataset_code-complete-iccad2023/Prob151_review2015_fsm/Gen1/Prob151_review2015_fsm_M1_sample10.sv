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

  parameter IDLE = 3'b000, PATTERN_DETECT = 3'b001, SHIFT_ENA = 3'b010, 
    COUNTING = 3'b011, DONE_WAIT = 3'b100, DONE_ACK_WAIT = 3'b101;
  
  reg [2:0] state, next_state;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
    end 
    else begin
      state <= next_state;
    end
  end
  
  always @* begin
    next_state = state;
    
    case (state)
      IDLE: begin
        if (data == 1 && $past(data) == 1 && $past($past(data)) == 0) begin
          next_state = PATTERN_DETECT;
        end
      end
      PATTERN_DETECT: begin
        next_state = (data == 1) ? SHIFT_ENA : IDLE;
      end
      SHIFT_ENA: begin
        next_state = COUNTING;
      end
      COUNTING: begin
        if (done_counting) begin
          next_state = DONE_WAIT;
        end
      end
      DONE_WAIT: begin
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
  
  always @* begin
    shift_ena = (state == SHIFT_ENA) ? 1 : 0;
    counting = (state == COUNTING) ? 1 : 0;
    done = (state == DONE_WAIT) ? 1 : 0;
  end

endmodule