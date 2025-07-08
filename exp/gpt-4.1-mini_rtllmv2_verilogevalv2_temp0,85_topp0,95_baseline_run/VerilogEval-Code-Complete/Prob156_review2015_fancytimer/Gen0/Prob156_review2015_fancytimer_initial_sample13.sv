module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  // FSM states
  typedef enum logic [1:0] {
    SEARCH = 2'b00,
    SHIFT_DELAY = 2'b01,
    COUNTING = 2'b10,
    DONE = 2'b11
  } state_t;
  
  state_t state, next_state;

  reg [3:0] shift_reg;    // shift register for pattern detection & delay shifting
  reg [2:0] shift_count;  // counts number of bits shifted for delay (0 to 3)
  
  reg [11:0] cycle_count; // counts 1000 clock cycles (0 to 999)
  reg [3:0] delay;        // holds delay value after shift in
  reg [3:0] delay_counter; // counts down from delay to 0
  
  // Parameters
  localparam PATTERN = 4'b1101;
  localparam CYCLES_PER_DELAY = 12'd1000;

  // Sequential FSM and registers
  always @(posedge clk) begin
    if (reset) begin
      // Reset all registers and FSM state
      state <= SEARCH;
      shift_reg <= 4'b0000;
      shift_count <= 0;
      cycle_count <= 0;
      delay <= 0;
      delay_counter <= 0;
      counting <= 0;
      done <= 0;
      count <= 4'bxxxx;
    end else begin
      state <= next_state;
      
      case(state)
        SEARCH: begin
          done <= 0;
          counting <= 0;
          count <= 4'bxxxx;
          cycle_count <= 0;
          shift_count <= 0;
          // Shift in data bit to shift_reg
          shift_reg <= {shift_reg[2:0], data};
        end

        SHIFT_DELAY: begin
          done <= 0;
          counting <= 0;
          // Shift in next 4 bits MSB first into shift_reg
          shift_reg <= {shift_reg[2:0], data};
          shift_count <= shift_count + 1;
          if (shift_count == 3) begin
            delay <= {shift_reg[2:0], data}; // last 4 bits shifted in are delay
            delay_counter <= {shift_reg[2:0], data};
            cycle_count <= 0;
          end
        end

        COUNTING: begin
          done <= 0;
          counting <= 1;
          count <= delay_counter;
          if (cycle_count == CYCLES_PER_DELAY - 1) begin
            cycle_count <= 0;
            if (delay_counter == 0) begin
              // Counting done
              counting <= 0;
            end else begin
              delay_counter <= delay_counter - 1;
              count <= delay_counter - 1;
            end
          end else begin
            cycle_count <= cycle_count + 1;
          end
        end

        DONE: begin
          done <= 1;
          counting <= 0;
          count <= 4'bxxxx;
          // Wait for ack = 1 to reset FSM to SEARCH
        end

      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case(state)
      SEARCH: begin
        // Transition to SHIFT_DELAY if pattern detected
        if (shift_reg == PATTERN)
          next_state = SHIFT_DELAY;
      end
      SHIFT_DELAY: begin
        // After shifting 4 bits delay, move to COUNTING
        if (shift_count == 3)
          next_state = COUNTING;
      end
      COUNTING: begin
        // After counting (delay+1)*1000 cycles, go to DONE
        if ((delay_counter == 0) && (cycle_count == CYCLES_PER_DELAY - 1))
          next_state = DONE;
      end
      DONE: begin
        // Wait for ack to go back to SEARCH
        if (ack)
          next_state = SEARCH;
      end
    endcase
  end

endmodule