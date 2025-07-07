module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  // FSM states
  typedef enum logic [1:0] {
    SEARCH = 2'b00,
    LOAD_DELAY = 2'b01,
    COUNT = 2'b10,
    DONE = 2'b11
  } state_t;

  state_t state, next_state;

  // Shift register for detecting pattern 1101
  reg [3:0] pattern_shift;

  // Delay register (4 bits)
  reg [3:0] delay;

  // Counter for bits shifted in LOAD_DELAY (4 bits)
  reg [2:0] load_bit_count; // counts 0 to 3

  // 10-bit counter for 1000 cycles
  reg [9:0] cycle_count;

  // 4-bit counter for delay countdown
  reg [3:0] delay_count;

  // Internal signals
  wire pattern_detected = (pattern_shift == 4'b1101);

  // Sequential logic for FSM and registers
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      pattern_shift <= 4'b0000;
      delay <= 4'b0000;
      load_bit_count <= 3'd0;
      cycle_count <= 10'd0;
      delay_count <= 4'd0;
      counting <= 1'b0;
      done <= 1'b0;
      count <= 4'bxxxx; // don't care
    end else begin
      state <= next_state;

      case (state)
        SEARCH: begin
          // Shift in data to detect pattern
          pattern_shift <= {pattern_shift[2:0], data};
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'bxxxx; // don't care
          load_bit_count <= 3'd0;
          cycle_count <= 10'd0;
          delay_count <= 4'd0;
          // delay register unchanged here
        end

        LOAD_DELAY: begin
          // Shift in 4 bits MSB first into delay
          // We shift in one bit per clock cycle, MSB first means first bit shifted is delay[3]
          // We'll shift left and insert data at LSB
          // But since MSB first, we can shift left and insert data at LSB
          delay <= {delay[2:0], data};
          load_bit_count <= load_bit_count + 1'b1;
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'bxxxx; // don't care
          pattern_shift <= 4'b0000; // no longer needed
          cycle_count <= 10'd0;
          delay_count <= 4'd0;
        end

        COUNT: begin
          counting <= 1'b1;
          done <= 1'b0;

          // cycle_count counts from 0 to 999
          if (cycle_count == 10'd999) begin
            cycle_count <= 10'd0;
            if (delay_count != 4'd0) begin
              delay_count <= delay_count - 1'b1;
            end
          end else begin
            cycle_count <= cycle_count + 1'b1;
          end

          // Output current remaining delay value on count
          count <= delay_count;
        end

        DONE: begin
          counting <= 1'b0;
          done <= 1'b1;
          count <= 4'bxxxx; // don't care
          // Wait for ack to return to SEARCH
        end

        default: begin
          // Should not happen
          state <= SEARCH;
          counting <= 1'b0;
          done <= 1'b0;
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
        if (pattern_detected) begin
          next_state = LOAD_DELAY;
        end
      end

      LOAD_DELAY: begin
        if (load_bit_count == 3'd3) begin
          next_state = COUNT;
        end
      end

      COUNT: begin
        // When delay_count == 0 and cycle_count == 999, counting done
        if ((delay_count == 4'd0) && (cycle_count == 10'd999)) begin
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

  // Initialize delay_count at start of COUNT state
  always @(posedge clk) begin
    if (reset) begin
      delay_count <= 4'd0;
    end else if (state == LOAD_DELAY && next_state == COUNT) begin
      // delay_count initialized to delay input
      delay_count <= delay;
    end
  end

endmodule