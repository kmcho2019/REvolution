module TimerStateMachine (
  input wire clk,
  input wire reset,
  input wire data,
  output wire [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  // State definitions
  parameter IDLE = 2'b00, DETECT_START = 2'b01, SHIFT_IN = 2'b10, COUNTING = 2'b11;
  reg [1:0] state, next_state;
  
  // Delay counter
  reg [3:0] delay;
  reg [11:0] counter;
  
  // Remaining time counter
  reg [3:0] remaining_time;
  
  always @ (posedge clk) begin
    if (reset) begin
      state <= IDLE;
      counting <= 0;
      done <= 0;
      delay <= 0;
      counter <= 0;
      remaining_time <= 0;
    end
    else begin
      state <= next_state;
      counting <= (state == COUNTING);
      if (counting) begin
        if (counter < (delay + 1) * 1000) begin
          counter <= counter + 1;
          if (counter % 1000 == 0) begin
            remaining_time <= remaining_time - 1;
          end
        end
        else begin
          done <= 1;
        end
      end
    end
  end
  
  always @* begin
    next_state = state;
    
    case (state)
      IDLE: begin
        if (data == 1) begin
          next_state = DETECT_START;
        end
      end
      
      DETECT_START: begin
        if (data == 1) begin
          next_state = DETECT_START;
        end
        else begin
          next_state = SHIFT_IN;
          delay <= 0;
        end
      end
      
      SHIFT_IN: begin
        // Shift in the next 4 bits to determine delay
        delay <= {data, delay[3:1]};
        next_state = COUNTING;
        counter <= 0;
        remaining_time <= delay;
      end
      
      COUNTING: begin
        if (counter >= (delay + 1) * 1000) begin
          next_state = IDLE;
        end
      end
    endcase
  end
  
  assign count = remaining_time;

endmodule