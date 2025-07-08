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
  typedef enum reg [1:0] {
    SEARCH = 2'b00,
    LOAD   = 2'b01,
    COUNT  = 2'b10,
    DONE_S = 2'b11
  } state_t;

  state_t state, next_state;

  reg [3:0] shift_pattern;  // for detecting 1101 pattern
  reg [3:0] delay;
  reg [2:0] load_bit_idx;   // counts bits loaded from 3 down to 0

  reg [9:0] cycle_counter;  // counts 0..999 for 1000 cycles
  reg [3:0] block_count;    // counts down from delay to 0 for blocks of 1000 cycles

  // Sequential logic
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      shift_pattern <= 4'b0000;
      delay <= 4'b0000;
      load_bit_idx <= 3'd0;
      cycle_counter <= 10'd0;
      block_count <= 4'd0;
      counting <= 1'b0;
      done <= 1'b0;
      count <= 4'b0000;
    end else begin
      state <= next_state;

      case (state)
        SEARCH: begin
          // shift in data bit to shift_pattern
          shift_pattern <= {shift_pattern[2:0], data};
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'b0000; // don't care in SEARCH
        end
        LOAD: begin
          // shift in delay bits MSB first: first bit is delay[3], then down to delay[0]
          delay <= {delay[2:0], data};
          load_bit_idx <= load_bit_idx - 1;
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'b0000; // don't care in LOAD
        end
        COUNT: begin
          counting <= 1'b1;
          done <= 1'b0;

          if (cycle_counter == 10'd999) begin
            cycle_counter <= 10'd0;
            // decrement block_count if > 0
            if (block_count != 4'd0)
              block_count <= block_count - 1;
          end else begin
            cycle_counter <= cycle_counter + 1;
          end

          count <= block_count;
        end
        DONE_S: begin
          counting <= 1'b0;
          done <= 1'b1;
          count <= 4'b0000; // don't care in DONE
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      SEARCH: begin
        // pattern detection: when shift_pattern is 1101 (binary 4'b1101)
        if (shift_pattern == 4'b1101)
          next_state = LOAD;
      end
      LOAD: begin
        if (load_bit_idx == 3'd0)
          next_state = COUNT;
      end
      COUNT: begin
        if ((block_count == 4'd0) && (cycle_counter == 10'd999))
          next_state = DONE_S;
      end
      DONE_S: begin
        if (ack)
          next_state = SEARCH;
      end
    endcase
  end

  // Initialize load_bit_idx when entering LOAD state
  always @(posedge clk) begin
    if (reset) begin
      load_bit_idx <= 3'd0;
    end else begin
      if ((state == SEARCH) && (next_state == LOAD)) begin
        load_bit_idx <= 3'd4; // 4 bits to load, count down to 0
        delay <= 4'b0000;
      end
    end
  end

  // Initialize counters when entering COUNT state
  always @(posedge clk) begin
    if (reset) begin
      cycle_counter <= 10'd0;
      block_count <= 4'd0;
    end else begin
      if ((state == LOAD) && (next_state == COUNT)) begin
        cycle_counter <= 10'd0;
        // block_count starts at delay value; counting down to 0 means (delay+1) blocks counting 1000 cycles each
        block_count <= delay;
      end
    end
  end

endmodule