module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  // State encoding
  typedef enum logic [2:0] {
    SEARCH = 3'd0,
    LOAD_DELAY = 3'd1,
    COUNT = 3'd2,
    DONE = 3'd3
  } state_t;

  state_t state, next_state;

  // Shift register for pattern detection (4 bits)
  reg [3:0] pattern_shift;

  // Delay bits loaded (4 bits)
  reg [3:0] delay;

  // For counting clock cycles within each delay segment (1000 cycles)
  reg [9:0] cycle_counter; // 10 bits to count up to 1000 (0..999)

  // For counting down the delay count (counts from delay down to 0)
  reg [3:0] delay_counter;

  // For loading delay bits (4 bits)
  reg [2:0] delay_bits_loaded; // counts 0..3

  // Next state logic and outputs
  always_ff @(posedge clk) begin
    if (reset) begin
      // Reset all registers
      state <= SEARCH;
      pattern_shift <= 4'b0000;
      delay <= 4'b0000;
      delay_bits_loaded <= 3'd0;
      counting <= 1'b0;
      done <= 1'b0;
      count <= 4'b0000;
      cycle_counter <= 10'd0;
      delay_counter <= 4'd0;
    end else begin
      state <= next_state;

      case (state)
        SEARCH: begin
          // Shift in new data bit
          pattern_shift <= {pattern_shift[2:0], data};
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'b0000; // don't-care, assign 0
          cycle_counter <= 10'd0;
          delay_bits_loaded <= 3'd0;
        end

        LOAD_DELAY: begin
          // Shift in delay bits MSB first
          // We shift left and insert data at LSB so final delay bits have MSB first
          delay <= {delay[2:0], data};
          delay_bits_loaded <= delay_bits_loaded + 3'd1;
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'b0000; // don't-care
        end

        COUNT: begin
          counting <= 1'b1;
          done <= 1'b0;

          if (cycle_counter == 10'd999) begin
            cycle_counter <= 10'd0;

            if (delay_counter == 4'd0) begin
              // counting done
              count <= 4'd0;
            end else begin
              delay_counter <= delay_counter - 4'd1;
              count <= delay_counter - 4'd1; // update count to remaining time
            end
          end else begin
            cycle_counter <= cycle_counter + 10'd1;
            // count remains same during the 1000 cycles
            count <= delay_counter;
          end
        end

        DONE: begin
          counting <= 1'b0;
          done <= 1'b1;
          count <= 4'b0000; // don't-care
        end

        default: begin
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'b0000;
        end
      endcase
    end
  end

  // Next state combinational logic
  always_comb begin
    next_state = state;
    case (state)
      SEARCH: begin
        if (pattern_shift == 4'b1101) begin
          next_state = LOAD_DELAY;
        end
      end

      LOAD_DELAY: begin
        if (delay_bits_loaded == 3'd3) begin
          next_state = COUNT;
        end
      end

      COUNT: begin
        // When delay_counter and cycle_counter both 0, transition to DONE
        if (delay_counter == 4'd0 && cycle_counter == 10'd999) begin
          next_state = DONE;
        end
      end

      DONE: begin
        if (ack == 1'b1) begin
          next_state = SEARCH;
        end
      end
    endcase
  end

  // Initialize delay_counter at transition from LOAD_DELAY to COUNT
  always_ff @(posedge clk) begin
    if (reset) begin
      delay_counter <= 4'd0;
    end else if (state == LOAD_DELAY && next_state == COUNT) begin
      // delay_counter loaded with delay from LOAD_DELAY after all bits shifted in
      delay_counter <= delay;
      count <= delay; // initial count output
      cycle_counter <= 10'd0;
    end
  end

endmodule