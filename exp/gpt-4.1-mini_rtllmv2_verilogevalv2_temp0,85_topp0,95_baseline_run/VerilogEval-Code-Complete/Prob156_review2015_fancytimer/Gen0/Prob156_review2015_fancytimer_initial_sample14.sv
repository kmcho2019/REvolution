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
    SEARCH = 2'd0,
    READ_DELAY = 2'd1,
    COUNT = 2'd2,
    DONE = 2'd3
  } state_t;

  state_t state, next_state;

  reg [3:0] shift_reg;      // For pattern detection and delay reading
  reg [3:0] delay;          // delay value
  reg [3:0] delay_counter;  // counts down from delay to 0
  reg [9:0] clk_count;      // counts 0 to 999

  // Synchronous state and registers update
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      shift_reg <= 4'd0;
      delay <= 4'd0;
      delay_counter <= 4'd0;
      clk_count <= 10'd0;
      count <= 4'dx;
      counting <= 1'b0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      case (state)
        SEARCH: begin
          // Shift in new data bit for pattern detection
          shift_reg <= {shift_reg[2:0], data};
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'dx;
        end

        READ_DELAY: begin
          // Shift in delay bits MSB first
          shift_reg <= {shift_reg[2:0], data};
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'dx;
        end

        COUNT: begin
          counting <= 1'b1;
          done <= 1'b0;

          if (clk_count == 10'd999) begin
            clk_count <= 10'd0;
            if (delay_counter != 0)
              delay_counter <= delay_counter - 1;
            count <= delay_counter;
          end else begin
            clk_count <= clk_count + 1;
            count <= delay_counter; // remain stable during 1000 cycles
          end
        end

        DONE: begin
          counting <= 1'b0;
          done <= 1'b1;
          count <= 4'dx;
        end

        default: begin
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'dx;
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      SEARCH: begin
        // Check if shift_reg == 1101 pattern
        if (shift_reg == 4'b1101)
          next_state = READ_DELAY;
      end

      READ_DELAY: begin
        // We need to shift in 4 delay bits, so after 4 bits are shifted in
        // shift_reg is used to read delay bits MSB first.
        // We count bits shifted in using a small counter or just count from outside,
        // but here we can count how many bits shifted by counting clock cycles in READ_DELAY.
        // We'll count how many bits shifted using a 2-bit counter.

        // To do this, we add a counter for bits shifted in delay
        // Implement a separate reg delay_bits_read below.
      end

      COUNT: begin
        // After counting (delay+1)*1000 cycles, go to DONE
        if ((delay_counter == 0) && (clk_count == 10'd999))
          next_state = DONE;
      end

      DONE: begin
        // Wait for ack == 1 to go back to SEARCH
        if (ack)
          next_state = SEARCH;
      end

    endcase
  end

  // Since we need to count bits read during READ_DELAY state,
  // add a 3-bit counter to count delay bits shifted (0 to 4)

  reg [2:0] delay_bits_read;

  always @(posedge clk) begin
    if (reset) begin
      delay_bits_read <= 3'd0;
    end else begin
      if (state == READ_DELAY) begin
        delay_bits_read <= delay_bits_read + 1;
      end else begin
        delay_bits_read <= 3'd0;
      end
    end
  end

  // After reading 4 bits, latch delay and move to COUNT
  always @(posedge clk) begin
    if (reset) begin
      delay <= 4'd0;
      delay_counter <= 4'd0;
      clk_count <= 10'd0;
    end else begin
      if (state == READ_DELAY && delay_bits_read == 3'd4) begin
        delay <= shift_reg;
        delay_counter <= shift_reg;
        clk_count <= 10'd0;
      end

      // clk_count and delay_counter update is handled above in the main always block
    end
  end

endmodule