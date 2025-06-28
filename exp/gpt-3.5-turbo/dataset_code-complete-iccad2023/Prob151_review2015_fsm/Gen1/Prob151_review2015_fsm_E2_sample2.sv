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
  
  always @* begin
    case (state)
      IDLE: begin
        next_state = (data == 1) ? PATTERN_DETECT : IDLE;
        shift_ena = 0;
        counting = 0;
        done = 0;
      end
      PATTERN_DETECT: begin
        next_state = (data == 1) ? SHIFT_ENA : IDLE;
        shift_ena = 0;
        counting = 0;
        done = 0;
      end
      SHIFT_ENA: begin
        next_state = COUNTING;
        shift_ena = 1;
        counting = 0;
        done = 0;
      end
      COUNTING: begin
        next_state = (done_counting) ? DONE_WAIT : COUNTING;
        shift_ena = 0;
        counting = 1;
        done = 0;
      end
      DONE_WAIT: begin
        next_state = (ack) ? DONE_ACK_WAIT : DONE_WAIT;
        shift_ena = 0;
        counting = 0;
        done = 1;
      end
      DONE_ACK_WAIT: begin
        next_state = (~ack) ? IDLE : DONE_ACK_WAIT;
        shift_ena = 0;
        counting = 0;
        done = 0;
      end
    endcase
  end

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
    end
    else begin
      state <= next_state;
    end
  end

endmodule