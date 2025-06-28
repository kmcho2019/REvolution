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
  
  // Define states for the Mealy state machine
  typedef enum logic [2:0] {
    IDLE,
    PATTERN_DETECTED,
    COUNT_CYCLES,
    TIMER_DONE
  } state_type;
  
  // Define registers for state machine and outputs
  reg [2:0] state, next_state;
  reg [1:0] delay_counter;
  
  // Mealy state machine logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      shift_ena <= 0;
      counting <= 0;
      done <= 0;
    end else begin
      state <= next_state;
    end
  end

  // Define the next state and output logic for the Mealy state machine
  always @* begin
    next_state = state;
    
    case (state)
      IDLE: begin
        if (data == 4'b1101) begin
          next_state = PATTERN_DETECTED;
          shift_ena = 1;
        end
      end
      
      PATTERN_DETECTED: begin
        if (shift_ena == 4) begin
          next_state = COUNT_CYCLES;
          shift_ena = 0;
        end else begin
          shift_ena = shift_ena + 1;
        end
      end
      
      COUNT_CYCLES: begin
        if (delay_counter == 2'b11) begin
          counting = 1;
          next_state = TIMER_DONE;
        end else begin
          delay_counter = delay_counter + 1;
        end
      end
      
      TIMER_DONE: begin
        done = 1;
        if (ack) begin
          next_state = IDLE;
          delay_counter = 0;
        end
      end
    endcase
  end
endmodule