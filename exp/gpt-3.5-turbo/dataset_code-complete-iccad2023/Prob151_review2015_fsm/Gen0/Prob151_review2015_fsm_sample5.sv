module TimerFSM (
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
parameter IDLE = 2'b00;
parameter DETECT_PATTERN = 2'b01;
parameter SHIFT = 2'b10;
parameter WAIT = 2'b11;
reg [1:0] state, next_state;

always @(*) begin
  case(state)
    IDLE: begin
      if(data == 4'b1101) begin
        next_state = DETECT_PATTERN;
      end else begin
        next_state = IDLE;
      end
    end
    
    DETECT_PATTERN: begin
      next_state = SHIFT;
    end
    
    SHIFT: begin
      next_state = WAIT;
    end
    
    WAIT: begin
      if(done_counting) begin
        next_state = DONE;
      end else begin
        next_state = WAIT;
      end
    end
    
    DONE: begin
      if(ack) begin
        next_state = IDLE;
      end else begin
        next_state = DONE;
      end
    end
  endcase
end

always @(posedge clk) begin
  if(reset) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

// Outputs logic
always @(state) begin
  case(state)
    IDLE: begin
      shift_ena = 1'b0;
      counting = 1'b0;
      done = 1'b0;
    end
    
    DETECT_PATTERN: begin
      shift_ena = 1'b0;
      counting = 1'b0;
      done = 1'b0;
    end
    
    SHIFT: begin
      shift_ena = 1'b1;
      counting = 1'b0;
      done = 1'b0;
    end
    
    WAIT: begin
      shift_ena = 1'b0;
      counting = 1'b1;
      done = 1'b0;
    end
    
    DONE: begin
      shift_ena = 1'b0;
      counting = 1'b0;
      done = 1'b1;
    end
  endcase
end

endmodule