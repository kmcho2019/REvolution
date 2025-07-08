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
    IDLE        = 2'b00,
    SHIFT_DELAY = 2'b01,
    COUNTING    = 2'b10,
    WAIT_ACK    = 2'b11
  } state_t;

  state_t state, next_state;

  reg [3:0] pattern_shift; // For detecting pattern 1101 and for shifting delay bits
  reg [3:0] delay;
  reg [3:0] remaining_count; // count down from delay to 0
  reg [9:0] cycle_count;     // counts 0 to 999 for 1000 cycles

  // Synchronous reset and state transition
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      pattern_shift <= 4'b0000;
      delay <= 4'b0000;
      remaining_count <= 4'b0000;
      cycle_count <= 10'd0;
      counting <= 1'b0;
      done <= 1'b0;
      count <= 4'b0000;
    end else begin
      state <= next_state;

      case (state)
        IDLE: begin
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'b0000; // don't care in idle
          // Shift in data to pattern_shift for pattern detection
          pattern_shift <= {pattern_shift[2:0], data};
        end

        SHIFT_DELAY: begin
          counting <= 1'b0;
          done <= 1'b0;
          // Shift in data bits to pattern_shift MSB first for delay
          pattern_shift <= {pattern_shift[2:0], data};
        end

        COUNTING: begin
          done <= 1'b0;
          counting <= 1'b1;
          count <= remaining_count;

          if (cycle_count == 10'd999) begin
            cycle_count <= 10'd0;
            if (remaining_count != 4'd0) begin
              remaining_count <= remaining_count - 1;
            end
          end else begin
            cycle_count <= cycle_count + 1;
          end
        end

        WAIT_ACK: begin
          counting <= 1'b0;
          done <= 1'b1;
          count <= 4'b0000; // don't care in done state
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      IDLE: begin
        if (pattern_shift == 4'b1101) begin
          next_state = SHIFT_DELAY;
        end
      end

      SHIFT_DELAY: begin
        // After shifting in 4 bits for delay, move to COUNTING
        // We receive one bit per clock, so after 4 bits shifted in total:
        // pattern_shift will hold the last 4 bits shifted in (the delay)
        // To know when 4 bits have been shifted in, count bits shifted in SHIFT_DELAY
        // We'll use a counter for bits shifted in delay, implicit in design below
        // But here, we track bits shifted in by counting clocks in SHIFT_DELAY state
        // Let's add a small register for this count.

        // To avoid combinational loops, we'll handle this in sequential block.

        // For next_state:
        // When bit count in SHIFT_DELAY == 4, move to COUNTING

        // As combinational logic, we can't know bit count here,
        // so we will track bit count in a register and update next_state in sequential block.

        // For now, keep next_state = SHIFT_DELAY here
      end

      COUNTING: begin
        // When counting finishes (remaining_count=0 and cycle_count=999),
        // move to WAIT_ACK.
        if ((remaining_count == 4'd0) && (cycle_count == 10'd999)) begin
          next_state = WAIT_ACK;
        end
      end

      WAIT_ACK: begin
        // Wait for ack=1 before returning to IDLE and searching for pattern
        if (ack) begin
          next_state = IDLE;
        end
      end
    endcase
  end

  // Additional logic for counting bits shifted in SHIFT_DELAY and capturing delay
  reg [2:0] shift_delay_bits; // counts 0 to 4

  always @(posedge clk) begin
    if (reset) begin
      shift_delay_bits <= 3'd0;
      delay <= 4'b0000;
      remaining_count <= 4'b0000;
    end else begin
      if (state == SHIFT_DELAY) begin
        shift_delay_bits <= shift_delay_bits + 1;
        if (shift_delay_bits == 3'd3) begin
          // After receiving 4 bits, pattern_shift holds delay
          delay <= pattern_shift;
          remaining_count <= pattern_shift;
        end
      end else begin
        shift_delay_bits <= 3'd0;
      end
    end
  end

  // Fix next_state for SHIFT_DELAY using shift_delay_bits
  always @(*) begin
    if (state == SHIFT_DELAY && shift_delay_bits == 3'd4) begin
      next_state = COUNTING;
    end
  end

endmodule