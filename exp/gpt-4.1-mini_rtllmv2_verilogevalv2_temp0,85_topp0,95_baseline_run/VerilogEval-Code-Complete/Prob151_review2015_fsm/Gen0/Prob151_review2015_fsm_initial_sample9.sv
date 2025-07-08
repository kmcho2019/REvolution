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
  
  // State encoding
  localparam S_SEARCH  = 3'd0;
  localparam S_SHIFT   = 3'd1;
  localparam S_COUNT   = 3'd2;
  localparam S_DONE    = 3'd3;
  
  reg [2:0] state, next_state;
  
  reg [3:0] shift_reg;      // For pattern detection
  reg [2:0] shift_count;    // Counts how many bits shifted in shift phase (0 to 4)
  
  // Pattern detection logic:
  // Shift data into shift_reg every clock in S_SEARCH
  // When shift_reg == 1101, start shift phase
  
  always @(posedge clk) begin
    if (reset) begin
      state <= S_SEARCH;
      shift_reg <= 4'b0000;
      shift_count <= 3'd0;
      shift_ena <= 1'b0;
      counting <= 1'b0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      
      case(state)
        S_SEARCH: begin
          // Shift data in shift_reg
          shift_reg <= {shift_reg[2:0], data};
          // Clear outputs during search
          shift_ena <= 1'b0;
          counting <= 1'b0;
          done <= 1'b0;
          shift_count <= 3'd0;
        end
        
        S_SHIFT: begin
          shift_ena <= 1'b1;
          counting <= 1'b0;
          done <= 1'b0;
          shift_reg <= shift_reg; // no shift needed here
          // Increment shift_count
          shift_count <= shift_count + 3'd1;
        end
        
        S_COUNT: begin
          shift_ena <= 1'b0;
          counting <= 1'b1;
          done <= 1'b0;
          shift_reg <= shift_reg; 
          shift_count <= 3'd0;
        end
        
        S_DONE: begin
          shift_ena <= 1'b0;
          counting <= 1'b0;
          done <= 1'b1;
          shift_reg <= shift_reg;
          shift_count <= 3'd0;
        end
        
        default: begin
          // default safe values
          shift_ena <= 1'b0;
          counting <= 1'b0;
          done <= 1'b0;
          shift_count <= 3'd0;
          shift_reg <= 4'b0000;
        end
      endcase
    end
  end
  
  // Next state logic combinational
  always @(*) begin
    next_state = state;
    case(state)
      S_SEARCH: begin
        // Detect pattern 1101 (binary 4'b1101 == 13 decimal)
        if (shift_reg == 4'b1101) begin
          next_state = S_SHIFT;
        end
      end
      
      S_SHIFT: begin
        // Shift_ena asserted for exactly 4 cycles
        if (shift_count == 3'd4) begin
          next_state = S_COUNT;
        end
      end
      
      S_COUNT: begin
        // Wait for done_counting to go high
        if (done_counting) begin
          next_state = S_DONE;
        end
      end
      
      S_DONE: begin
        // Wait for ack to go high to restart
        if (ack) begin
          next_state = S_SEARCH;
        end
      end
      
      default: next_state = S_SEARCH;
    endcase
  end

endmodule