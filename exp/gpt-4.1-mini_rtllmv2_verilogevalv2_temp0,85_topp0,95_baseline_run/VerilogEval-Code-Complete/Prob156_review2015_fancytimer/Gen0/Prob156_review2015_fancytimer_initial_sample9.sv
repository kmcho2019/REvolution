module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  // States encoding
  localparam SEARCH     = 2'd0;
  localparam LOAD_DELAY = 2'd1;
  localparam COUNT      = 2'd2;
  localparam DONE       = 2'd3;

  reg [1:0] state, next_state;

  // For pattern detection: shift register 4 bits
  reg [3:0] pattern_shift;

  // For loading delay bits (4 bits)
  reg [3:0] delay;
  reg [2:0] load_count; // counts from 0 to 3 for delay bits loaded

  // For counting cycles
  reg [9:0] cycle_count; // counts from 0 to 999 (1000 cycles)
  reg [3:0] interval_count; // counts intervals from delay down to 0

  // Next count value logic (to be output)
  reg [3:0] count_next;

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      pattern_shift <= 4'd0;
      delay <= 4'd0;
      load_count <= 3'd0;
      cycle_count <= 10'd0;
      interval_count <= 4'd0;
      count <= 4'd0;
      counting <= 1'b0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      case (state)
        SEARCH: begin
          // Shift in data bit for pattern detection
          pattern_shift <= {pattern_shift[2:0], data};
          // Clear outputs
          delay <= delay;
          load_count <= 3'd0;
          cycle_count <= 10'd0;
          interval_count <= 4'd0;
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'd0; // don't care during SEARCH, set 0
        end

        LOAD_DELAY: begin
          // Shift in delay bits MSB first
          // load_count counts bits shifted in from 0 to 3
          load_count <= load_count + 1'b1;
          delay <= {delay[2:0], data};
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'd0; // don't care during LOAD_DELAY
          cycle_count <= 10'd0;
          interval_count <= 4'd0;
          pattern_shift <= pattern_shift; // no change
        end

        COUNT: begin
          // Counting state
          counting <= 1'b1;
          done <= 1'b0;
          pattern_shift <= pattern_shift; // no change
          load_count <= load_count;
          delay <= delay;

          // cycle_count increments
          if (cycle_count == 10'd999) begin
            cycle_count <= 10'd0;
            // interval_count decrements every 1000 cycles, starting from delay down to 0
            if (interval_count != 4'd0) begin
              interval_count <= interval_count - 1'b1;
            end else begin
              interval_count <= 4'd0;
            end
          end else begin
            cycle_count <= cycle_count + 1'b1;
            interval_count <= interval_count;
          end

          // Update count output
          count <= interval_count;
        end

        DONE: begin
          // Timer done, assert done until ack=1
          done <= 1'b1;
          counting <= 1'b0;
          pattern_shift <= pattern_shift;
          delay <= delay;
          load_count <= load_count;
          cycle_count <= 10'd0;
          interval_count <= 4'd0;
          count <= 4'd0; // don't care in DONE
        end

        default: begin
          // safety fallback
          state <= SEARCH;
          pattern_shift <= 4'd0;
          delay <= 4'd0;
          load_count <= 3'd0;
          cycle_count <= 10'd0;
          interval_count <= 4'd0;
          count <= 4'd0;
          counting <= 1'b0;
          done <= 1'b0;
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      SEARCH: begin
        // Check if pattern_shift == 4'b1101
        if (pattern_shift == 4'b1101) begin
          next_state = LOAD_DELAY;
        end else begin
          next_state = SEARCH;
        end
      end

      LOAD_DELAY: begin
        // After shifting in 4 bits delay, move to COUNT
        if (load_count == 3'd3) begin
          next_state = COUNT;
        end else begin
          next_state = LOAD_DELAY;
        end
      end

      COUNT: begin
        // Count for (delay+1)*1000 cycles
        // We count intervals down from delay to 0, each interval is 1000 cycles
        // When interval_count == 0 and cycle_count == 999, counting is done
        if ((interval_count == 4'd0) && (cycle_count == 10'd999)) begin
          next_state = DONE;
        end else begin
          next_state = COUNT;
        end
      end

      DONE: begin
        // Wait for ack==1 to return to SEARCH
        if (ack == 1'b1) begin
          next_state = SEARCH;
        end else begin
          next_state = DONE;
        end
      end

      default: next_state = SEARCH;
    endcase
  end

  // Initialize interval_count at start of COUNT state
  always @(posedge clk) begin
    if (reset) begin
      interval_count <= 4'd0;
    end else begin
      // When moving from LOAD_DELAY to COUNT, set interval_count = delay
      if (state == LOAD_DELAY && next_state == COUNT) begin
        interval_count <= delay;
        cycle_count <= 10'd0;
        count <= delay; // set initial count output
      end
    end
  end

endmodule