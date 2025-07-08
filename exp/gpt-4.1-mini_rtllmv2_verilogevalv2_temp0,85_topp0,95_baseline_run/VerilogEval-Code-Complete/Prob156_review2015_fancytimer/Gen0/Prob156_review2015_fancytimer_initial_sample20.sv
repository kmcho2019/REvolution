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
  localparam SEARCH      = 2'd0;
  localparam LOAD_DELAY  = 2'd1;
  localparam COUNTING    = 2'd2;
  localparam DONE        = 2'd3;

  reg [1:0] state, next_state;

  // Shift register to detect pattern 1101
  reg [3:0] pattern_shift;

  // Shift register to load delay bits (MSB first)
  reg [3:0] delay;

  // Counter for bits loaded into delay
  reg [2:0] delay_bits_loaded; // max 4 bits needed

  // Cycle counter to count 1000 cycles per delay decrement
  reg [9:0] cycle_counter; // 10 bits needed for 0-999

  // Remaining delay counter for countdown
  reg [3:0] remaining_delay;

  // Next state logic and outputs handled synchronously
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      pattern_shift <= 4'b0000;
      delay <= 4'b0000;
      delay_bits_loaded <= 0;
      cycle_counter <= 0;
      remaining_delay <= 0;
      counting <= 1'b0;
      done <= 1'b0;
      count <= 4'b0000;
    end else begin
      state <= next_state;

      case (state)
        SEARCH: begin
          // Shift in data to detect pattern 1101
          pattern_shift <= {pattern_shift[2:0], data};
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'b0000;
          delay_bits_loaded <= 0;
          cycle_counter <= 0;
          remaining_delay <= 0;
          delay <= 4'b0000;
        end
        LOAD_DELAY: begin
          // Shift in delay bits MSB first (most significant bit first means the first bit shifted in is delay[3])
          delay <= {delay[2:0], data};
          delay_bits_loaded <= delay_bits_loaded + 1;
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'b0000;
          // pattern_shift not used here
        end
        COUNTING: begin
          counting <= 1'b1;
          done <= 1'b0;

          // increment cycle_counter
          if (cycle_counter == 999) begin
            cycle_counter <= 0;
            if (remaining_delay != 0) begin
              remaining_delay <= remaining_delay - 1;
            end
          end else begin
            cycle_counter <= cycle_counter + 1;
          end

          count <= remaining_delay;
        end
        DONE: begin
          counting <= 1'b0;
          done <= 1'b1;
          count <= 4'b0000;
          // Wait for ack to reset
        end
        default: begin
          // Should never happen
          state <= SEARCH;
          pattern_shift <= 4'b0000;
          delay <= 4'b0000;
          delay_bits_loaded <= 0;
          cycle_counter <= 0;
          remaining_delay <= 0;
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'b0000;
        end
      endcase
    end
  end

  // Next state logic combinational
  always @(*) begin
    next_state = state;
    case (state)
      SEARCH: begin
        if (pattern_shift == 4'b1101) begin
          next_state = LOAD_DELAY;
        end else begin
          next_state = SEARCH;
        end
      end
      LOAD_DELAY: begin
        if (delay_bits_loaded == 4) begin
          next_state = COUNTING;
        end else begin
          next_state = LOAD_DELAY;
        end
      end
      COUNTING: begin
        if ((remaining_delay == 0) && (cycle_counter == 999)) begin
          next_state = DONE;
        end else begin
          next_state = COUNTING;
        end
      end
      DONE: begin
        if (ack) begin
          next_state = SEARCH;
        end else begin
          next_state = DONE;
        end
      end
      default: next_state = SEARCH;
    endcase
  end

  // On transition from LOAD_DELAY to COUNTING, initialize remaining_delay and cycle_counter
  always @(posedge clk) begin
    if (!reset) begin
      if ((state == LOAD_DELAY) && (delay_bits_loaded == 4)) begin
        // Start counting with remaining_delay = delay and cycle_counter = 0
        remaining_delay <= delay;
        cycle_counter <= 0;
      end
    end
  end

endmodule