module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  // States
  localparam STATE_SEARCH     = 2'd0;
  localparam STATE_LOAD_DELAY = 2'd1;
  localparam STATE_COUNT      = 2'd2;
  localparam STATE_DONE       = 2'd3;

  reg [1:0] state, next_state;

  // Shift register to detect pattern 1101
  reg [3:0] pattern_shift;

  // For loading delay bits MSB first, count 4 bits
  reg [2:0] load_bit_cnt; // counts 0 to 3

  // Store delay value
  reg [3:0] delay;

  // Cycle counter counts 0 to 999 (1000 cycles)
  reg [9:0] cycle_counter;

  // Remaining delay counter, counts down from delay to 0
  reg [3:0] delay_counter;

  // Sequential logic
  always @(posedge clk) begin
    if (reset) begin
      state <= STATE_SEARCH;
      pattern_shift <= 4'd0;
      load_bit_cnt <= 3'd0;
      delay <= 4'd0;
      cycle_counter <= 10'd0;
      delay_counter <= 4'd0;
      counting <= 1'b0;
      done <= 1'b0;
      count <= 4'd0;
    end else begin
      state <= next_state;

      case (state)
        STATE_SEARCH: begin
          done <= 1'b0;
          counting <= 1'b0;
          count <= 4'd0; // don't-care; zero here
          // Shift in data bit
          pattern_shift <= {pattern_shift[2:0], data};
        end

        STATE_LOAD_DELAY: begin
          done <= 1'b0;
          counting <= 1'b0;
          count <= 4'd0; // don't care

          // Shift in delay bits MSB first
          delay <= {delay[2:0], data};
          load_bit_cnt <= load_bit_cnt + 1'b1;
        end

        STATE_COUNT: begin
          done <= 1'b0;
          counting <= 1'b1;
          count <= delay_counter;

          if (cycle_counter == 10'd999) begin
            cycle_counter <= 10'd0;
            if (delay_counter != 4'd0)
              delay_counter <= delay_counter - 1'b1;
          end else begin
            cycle_counter <= cycle_counter + 1'b1;
          end
        end

        STATE_DONE: begin
          done <= 1'b1;
          counting <= 1'b0;
          count <= 4'd0; // don't care
          // Wait for ack to return to SEARCH
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;

    case (state)
      STATE_SEARCH: begin
        // Detect pattern 1101 in pattern_shift
        // pattern_shift = {bit3, bit2, bit1, bit0}, bit3 is oldest bit
        if (pattern_shift == 4'b1101) begin
          next_state = STATE_LOAD_DELAY;
        end
      end

      STATE_LOAD_DELAY: begin
        if (load_bit_cnt == 3'd3) begin
          // Loaded all 4 bits
          next_state = STATE_COUNT;
        end
      end

      STATE_COUNT: begin
        // Wait until full delay counted ((delay + 1)*1000 cycles)
        // Counting done when delay_counter=0 and cycle_counter=999
        if ((delay_counter == 4'd0) && (cycle_counter == 10'd999)) begin
          next_state = STATE_DONE;
        end
      end

      STATE_DONE: begin
        if (ack == 1'b1) begin
          next_state = STATE_SEARCH;
        end
      end
    endcase
  end

  // Initialize counters when entering states
  // Use state change detection
  reg [1:0] state_d;
  always @(posedge clk) begin
    state_d <= state;
  end

  wire state_changed = (state != state_d);

  always @(posedge clk) begin
    if (reset) begin
      load_bit_cnt <= 3'd0;
      cycle_counter <= 10'd0;
      delay_counter <= 4'd0;
      delay <= 4'd0;
    end else if (state_changed) begin
      case (next_state)
        STATE_LOAD_DELAY: begin
          load_bit_cnt <= 3'd0;
          delay <= 4'd0;
        end
        STATE_COUNT: begin
          cycle_counter <= 10'd0;
          delay_counter <= delay;
        end
        STATE_DONE: begin
          // no counter reset needed here
        end
        STATE_SEARCH: begin
          pattern_shift <= 4'd0;
        end
      endcase
    end
  end

endmodule