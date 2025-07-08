module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  // States of the FSM
  typedef enum reg [2:0] {
    SEARCH = 3'b000,
    SHIFT_DELAY = 3'b001,
    COUNT = 3'b010,
    DONE = 3'b011
  } state_t;

  reg [2:0] state, next_state;

  // Shift register to detect 1101 pattern
  reg [3:0] pattern_shift;

  // Shift register to collect delay bits
  reg [3:0] delay;
  reg [2:0] delay_bits_count; // counts how many delay bits shifted in (0 to 4)

  // For counting 1000 cycles per delay decrement
  reg [9:0] cycle_counter; // counts 0..999

  // Current countdown value (copy of delay at start of counting)
  reg [3:0] current_count;

  // FSM sequential logic and outputs
  always @(posedge clk) begin
    if (reset) begin
      // Reset all
      state <= SEARCH;
      pattern_shift <= 4'b0;
      delay <= 4'b0;
      delay_bits_count <= 3'd0;
      cycle_counter <= 10'd0;
      current_count <= 4'd0;
      counting <= 1'b0;
      done <= 1'b0;
      count <= 4'bxxxx; // don't care
    end else begin
      case(state)
        SEARCH: begin
          done <= 1'b0;
          counting <= 1'b0;
          count <= 4'bxxxx; // don't care
          // Shift in new data bit into pattern_shift
          pattern_shift <= {pattern_shift[2:0], data};
          if (pattern_shift == 4'b1101) begin
            // Detected pattern, move to SHIFT_DELAY next cycle
            state <= SHIFT_DELAY;
            delay <= 4'b0;
            delay_bits_count <= 3'd0;
          end else begin
            // Stay in SEARCH
            state <= SEARCH;
          end
        end

        SHIFT_DELAY: begin
          // Shift in delay bits MSB first: we shift left and input data as LSB
          delay <= {delay[2:0], data};
          delay_bits_count <= delay_bits_count + 1'b1;
          if (delay_bits_count == 3'd3) begin
            // After 4 bits shifted in, move to COUNT
            state <= COUNT;
            current_count <= {delay[2:0], data}; // full 4 bits delay
            cycle_counter <= 10'd0;
            counting <= 1'b1;
            done <= 1'b0;
            count <= {delay[2:0], data};
          end else begin
            state <= SHIFT_DELAY;
          end
        end

        COUNT: begin
          counting <= 1'b1;
          done <= 1'b0;
          count <= current_count;

          if (cycle_counter == 10'd999) begin
            cycle_counter <= 10'd0;
            if (current_count == 4'd0) begin
              // Counting done, move to DONE
              state <= DONE;
              counting <= 1'b0;
              done <= 1'b1;
              count <= 4'bxxxx; // don't care
            end else begin
              // Decrement current_count and continue counting
              current_count <= current_count - 1'b1;
            end
          end else begin
            cycle_counter <= cycle_counter + 1'b1;
            state <= COUNT;
          end
        end

        DONE: begin
          counting <= 1'b0;
          done <= 1'b1;
          count <= 4'bxxxx; // don't care
          // Wait for ack to go high
          if (ack) begin
            // Reset to search for new pattern
            state <= SEARCH;
            pattern_shift <= 4'b0;
            delay <= 4'b0;
            delay_bits_count <= 3'd0;
            cycle_counter <= 10'd0;
            current_count <= 4'd0;
            done <= 1'b0;
          end else begin
            state <= DONE;
          end
        end

        default: begin
          // Should not happen: reset to SEARCH
          state <= SEARCH;
          pattern_shift <= 4'b0;
          delay <= 4'b0;
          delay_bits_count <= 3'd0;
          cycle_counter <= 10'd0;
          current_count <= 4'd0;
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'bxxxx;
        end
      endcase
    end
  end

endmodule