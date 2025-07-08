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
  typedef enum reg [1:0] {
    SEARCH = 2'b00,
    LOAD_DELAY = 2'b01,
    COUNTING = 2'b10,
    DONE = 2'b11
  } state_t;

  state_t state, next_state;

  reg [3:0] shift_reg; // to detect pattern and load delay
  reg [2:0] load_count; // counts 4 bits for delay loading
  reg [3:0] delay;      // delay loaded after pattern detected

  reg [3:0] count_reg;  // current count output for delay countdown (0 to delay)
  reg [9:0] cycle_count; // counts 1000 cycles per count step (max 1000 cycles -> needs 10 bits)

  // Sequential state and registers update
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      shift_reg <= 4'b0000;
      load_count <= 3'd0;
      delay <= 4'd0;
      count_reg <= 4'd0;
      cycle_count <= 10'd0;
      counting <= 1'b0;
      done <= 1'b0;
      count <= 4'bxxxx; // don't care on reset
    end else begin
      state <= next_state;

      case (state)
        SEARCH: begin
          // Shift in data
          shift_reg <= {shift_reg[2:0], data};
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'bxxxx;
          load_count <= 3'd0;
          cycle_count <= 10'd0;
          count_reg <= 4'd0;
        end

        LOAD_DELAY: begin
          // Shift in delay bits MSB first
          shift_reg <= {shift_reg[2:0], data};
          load_count <= load_count + 1'b1;
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'bxxxx;
          cycle_count <= 10'd0;
          count_reg <= 4'd0;
        end

        COUNTING: begin
          counting <= 1'b1;
          done <= 1'b0;
          count <= count_reg;

          if (cycle_count == 10'd999) begin
            cycle_count <= 10'd0;
            // Decrement count_reg if not zero
            if (count_reg != 0)
              count_reg <= count_reg - 1'b1;
          end else begin
            cycle_count <= cycle_count + 1'b1;
          end
        end

        DONE: begin
          counting <= 1'b0;
          done <= 1'b1;
          count <= 4'bxxxx;
        end

      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      SEARCH: begin
        // When shift_reg equals 1101 (binary 4'b1101), go to LOAD_DELAY
        if (shift_reg == 4'b1101)
          next_state = LOAD_DELAY;
      end

      LOAD_DELAY: begin
        if (load_count == 3'd3)
          next_state = COUNTING;
      end

      COUNTING: begin
        // When count_reg reaches 0 and cycle_count reaches 999 (end of last 1000 cycles)
        if ((count_reg == 0) && (cycle_count == 10'd999))
          next_state = DONE;
      end

      DONE: begin
        if (ack == 1'b1)
          next_state = SEARCH;
      end
    endcase
  end

  // Update delay and count_reg after loading delay bits
  always @(posedge clk) begin
    if (!reset) begin
      if (state == LOAD_DELAY && load_count == 3'd3) begin
        delay <= {shift_reg[2:0], data}; // after shifting last bit in next cycle shift_reg will have 4 bits but the last bit is data now, so we combine manually
        count_reg <= {shift_reg[2:0], data};
      end
      if (state == COUNTING && next_state == COUNTING && load_count == 3'd3) begin
        // count_reg and delay already set above at load finish
        // nothing to do here
      end
      if (state == COUNTING && next_state == COUNTING && cycle_count == 10'd999 && count_reg != 0) begin
        // count_reg is decremented in sequential block
      end
    end
  end

endmodule