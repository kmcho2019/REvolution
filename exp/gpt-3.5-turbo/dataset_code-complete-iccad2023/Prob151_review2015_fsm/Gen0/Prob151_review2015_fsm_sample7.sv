module TimerStateMachine (
  input clk,
  input reset,
  input data,
  output reg shift_ena,
  output reg counting,
  input done_counting,
  output reg done,
  input ack
);
  
  // State definitions
  parameter IDLE = 2'b00;  // Initial state
  parameter DETECT_PATTERN = 2'b01;  // State to detect the pattern '1101'
  parameter SHIFT_ENA = 2'b10;  // State to assert shift_ena for 4 clock cycles
  parameter WAIT_COUNT = 2'b11;  // State to wait for done_counting to be high
  
  // Internal signals
  reg [1:0] state, next_state;
  reg shift_ena_next, counting_next, done_next;
  
  // State machine
  always @ (posedge clk or posedge reset)
  begin
    if (reset) begin
      state <= IDLE;
    end
    else begin
      state <= next_state;
    end
  end
  
  // State transitions and outputs
  always @ *
  begin
    case (state)
      IDLE: begin
        if (data == 4'b1101) begin
          next_state = DETECT_PATTERN;
          shift_ena_next = 0;
          counting_next = 0;
          done_next = 0;
        end
        else begin
          next_state = IDLE;
          shift_ena_next = 0;
          counting_next = 0;
          done_next = 0;
        end
      end
      
      DETECT_PATTERN: begin
        next_state = SHIFT_ENA;
        shift_ena_next = 1;
        counting_next = 0;
        done_next = 0;
      end
      
      SHIFT_ENA: begin
        next_state = WAIT_COUNT;
        shift_ena_next = (shift_ena == 4'hF) ? 0 : 1;
        counting_next = 0;
        done_next = 0;
      end
      
      WAIT_COUNT: begin
        if (done_counting) begin
          next_state = IDLE;
          shift_ena_next = 0;
          counting_next = 1;
          done_next = 0;
        end
        else begin
          next_state = WAIT_COUNT;
          shift_ena_next = 0;
          counting_next = 0;
          done_next = 0;
        end
      end
      
      default: begin
        next_state = IDLE;
        shift_ena_next = 0;
        counting_next = 0;
        done_next = 0;
      end
    endcase
  end
  
  // Assign next state values to current state
  always @ *
  begin
    shift_ena = shift_ena_next;
    counting = counting_next;
    done = done_next;
  end
  
endmodule