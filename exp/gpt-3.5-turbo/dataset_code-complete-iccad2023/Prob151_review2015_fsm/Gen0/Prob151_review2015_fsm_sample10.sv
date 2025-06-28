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
  
  parameter IDLE = 2'b00, PATTERN_DETECT = 2'b01, SHIFT_ENA = 2'b10, 
    COUNTING = 2'b11, DONE_WAIT = 2'b100, DONE_ACK_WAIT = 2'b101;
  
  reg [1:0] state, next_state;
  
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
        if (data == 1 && $past(data) == 0) begin
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
    shift_ena = 0;
    counting = 0;
    done = 0;
    
    case (state)
      SHIFT_ENA: begin
        shift_ena = 1;
      end
      COUNTING: begin
        counting = 1;
      end
      DONE_WAIT: begin
        done = 1;
      end
    endcase
  end

endmodule