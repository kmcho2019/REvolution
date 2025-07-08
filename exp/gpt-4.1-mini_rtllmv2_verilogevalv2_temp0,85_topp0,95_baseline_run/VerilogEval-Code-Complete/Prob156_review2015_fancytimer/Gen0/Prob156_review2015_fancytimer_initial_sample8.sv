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
localparam SEARCH     = 2'b00;
localparam READ_DELAY = 2'b01;
localparam COUNT      = 2'b10;
localparam DONE       = 2'b11;

reg [1:0] state, next_state;

// For detecting start pattern 1101 (4 bits)
// We'll keep a 4-bit shift register for incoming data
reg [3:0] shift_pattern;

// For reading delay bits (4 bits) MSB first
reg [2:0] delay_bit_idx;  // counts 0 to 3 bits shifted in
reg [3:0] delay_reg;

// For counting 1000 clock cycles per delay count
reg [9:0] clk_counter; // 10-bit to count 0-999

// For counting down delay counts (0 to delay_reg)
reg [3:0] delay_countdown;

always @(posedge clk) begin
  if (reset) begin
    state <= SEARCH;
    shift_pattern <= 4'b0000;
    delay_reg <= 4'b0000;
    delay_bit_idx <= 3'd0;
    clk_counter <= 10'd0;
    delay_countdown <= 4'd0;
    counting <= 1'b0;
    done <= 1'b0;
    count <= 4'bxxxx;
  end else begin
    state <= next_state;
    case (state)
      SEARCH: begin
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'bxxxx;
        // Shift in data for pattern detection
        shift_pattern <= {shift_pattern[2:0], data};
      end

      READ_DELAY: begin
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'bxxxx;

        // Shift in delay bits MSB first
        // delay_bit_idx goes 0 to 3
        // Shift delay_reg left by 1 and add data bit
        delay_reg <= {delay_reg[2:0], data};
        delay_bit_idx <= delay_bit_idx + 1'b1;
      end

      COUNT: begin
        counting <= 1'b1;
        done <= 1'b0;

        // During counting, count down delay_countdown every 1000 cycles
        // clk_counter counts from 0 to 999

        if (clk_counter == 10'd999) begin
          clk_counter <= 10'd0;
          // Decrement delay_countdown if not zero
          if (delay_countdown != 4'd0)
            delay_countdown <= delay_countdown - 1'b1;
        end else begin
          clk_counter <= clk_counter + 1'b1;
        end

        count <= delay_countdown;
      end

      DONE: begin
        counting <= 1'b0;
        done <= 1'b1;
        count <= 4'bxxxx;
      end

      default: begin
        // Should not occur
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'bxxxx;
      end
    endcase
  end
end

// FSM next state logic
always @(*) begin
  next_state = state;
  case (state)
    SEARCH: begin
      // Pattern detected when shift_pattern == 1101
      if (shift_pattern == 4'b1101) begin
        next_state = READ_DELAY;
      end
    end

    READ_DELAY: begin
      if (delay_bit_idx == 3'd4) begin
        // Finished reading 4 bits of delay
        next_state = COUNT;
      end
    end

    COUNT: begin
      // Move to DONE after counting completes
      // Counting is (delay_reg + 1) * 1000 cycles
      // delay_countdown counts down from delay_reg to 0
      // When delay_countdown==0 and clk_counter==999, counting done
      if (delay_countdown == 4'd0 && clk_counter == 10'd999) begin
        next_state = DONE;
      end
    end

    DONE: begin
      if (ack) begin
        next_state = SEARCH;
      end
    end

    default: next_state = SEARCH;
  endcase
end

// Control signals update on state transitions
always @(posedge clk) begin
  if (reset) begin
    delay_bit_idx <= 3'd0;
    delay_reg <= 4'd0;
    delay_countdown <= 4'd0;
    clk_counter <= 10'd0;
  end else begin
    case (state)
      SEARCH: begin
        // Reset delay_bit_idx each time searching
        delay_bit_idx <= 3'd0;
        delay_reg <= 4'd0;
        delay_countdown <= 4'd0;
        clk_counter <= 10'd0;
      end

      READ_DELAY: begin
        if (delay_bit_idx == 3'd4) begin
          // On finish reading delay bits, initialize countdown and clk_counter
          delay_countdown <= delay_reg;
          clk_counter <= 10'd0;
        end
      end

      COUNT: begin
        // clk_counter and delay_countdown update in main always block above
      end

      DONE: begin
        // Hold values
      end
    endcase
  end
end

endmodule