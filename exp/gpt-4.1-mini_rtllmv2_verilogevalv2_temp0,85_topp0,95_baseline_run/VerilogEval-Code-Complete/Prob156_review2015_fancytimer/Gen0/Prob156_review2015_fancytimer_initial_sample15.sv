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
  typedef enum logic [1:0] {
    SEARCH    = 2'd0,
    LOAD_DELAY= 2'd1,
    COUNT     = 2'd2,
    DONE      = 2'd3
  } state_t;

  state_t state, next_state;

  reg [3:0] shift_reg;      // For detecting pattern 1101 (MSB at shift_reg[3])
  reg [2:0] delay_bit_cnt;  // Count bits loaded for delay (0 to 3)
  reg [3:0] delay;          // delay[3:0] loaded after pattern detected

  reg [9:0] cycle_cnt;      // Counts clock cycles up to 1000 (max 1000 cycles)
  reg [3:0] remain_delay;   // counts down from delay to 0 during counting

  // Sequential logic: state transitions and registers update
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      shift_reg <= 4'd0;
      delay <= 4'd0;
      delay_bit_cnt <= 3'd0;
      cycle_cnt <= 10'd0;
      remain_delay <= 4'd0;
      counting <= 1'b0;
      done <= 1'b0;
      count <= 4'd0;
    end else begin
      state <= next_state;
      case (state)
        SEARCH: begin
          // Shift in data bit
          shift_reg <= {shift_reg[2:0], data};
          // outputs cleared/not counting
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'd0; // don't care when not counting
          delay_bit_cnt <= 3'd0;
        end

        LOAD_DELAY: begin
          // Shift in delay bits MSB first
          // shift_reg is used to accumulate delay bits here (4-bit)
          shift_reg <= {shift_reg[2:0], data};
          delay_bit_cnt <= delay_bit_cnt + 1'b1;
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'd0;
        end

        COUNT: begin
          counting <= 1'b1;
          done <= 1'b0;
          count <= remain_delay;

          if (cycle_cnt == 10'd999) begin
            cycle_cnt <= 10'd0;
            // decrement remain_delay if > 0 else stay 0
            if (remain_delay != 4'd0)
              remain_delay <= remain_delay - 1'b1;
          end else begin
            cycle_cnt <= cycle_cnt + 1'b1;
          end
        end

        DONE: begin
          counting <= 1'b0;
          done <= 1'b1;
          count <= 4'd0;
        end

        default: begin
          // Should not happen; just reset outputs
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'd0;
        end
      endcase

      // Latch delay value when finished loading delay bits
      if (state == LOAD_DELAY && delay_bit_cnt == 3'd3) begin
        delay <= {shift_reg[2:0], data}; // include current data bit shifted in MSB first
      end
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      SEARCH: begin
        // Check if shift_reg matches pattern 1101 (shift_reg[3:0] == 4'b1101)
        // Since shift_reg was updated previous clock, data just shifted in
        if (shift_reg == 4'b1101) begin
          next_state = LOAD_DELAY;
        end else begin
          next_state = SEARCH;
        end
      end

      LOAD_DELAY: begin
        if (delay_bit_cnt == 3'd3) begin
          // After loading 4 bits, move to COUNT
          next_state = COUNT;
        end else begin
          next_state = LOAD_DELAY;
        end
      end

      COUNT: begin
        // Counting lasts (delay+1)*1000 cycles
        // When remain_delay is 0 and cycle_cnt is 999, counting done
        if ((remain_delay == 4'd0) && (cycle_cnt == 10'd999)) begin
          next_state = DONE;
        end else begin
          next_state = COUNT;
        end
      end

      DONE: begin
        // Wait for ack to return to SEARCH
        if (ack == 1'b1) begin
          next_state = SEARCH;
        end else begin
          next_state = DONE;
        end
      end

      default: begin
        next_state = SEARCH;
      end
    endcase
  end

  // Initialize remain_delay and cycle_cnt when entering COUNT state
  always @(posedge clk) begin
    if (reset) begin
      remain_delay <= 4'd0;
      cycle_cnt <= 10'd0;
    end else begin
      if (state != COUNT && next_state == COUNT) begin
        remain_delay <= delay;
        cycle_cnt <= 10'd0;
      end
    end
  end

endmodule