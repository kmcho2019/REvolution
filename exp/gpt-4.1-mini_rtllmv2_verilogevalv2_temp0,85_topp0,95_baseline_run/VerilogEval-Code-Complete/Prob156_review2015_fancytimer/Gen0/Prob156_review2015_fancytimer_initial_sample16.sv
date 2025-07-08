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
  localparam SEARCH     = 2'd0;
  localparam READ_DELAY = 2'd1;
  localparam COUNT      = 2'd2;
  localparam DONE       = 2'd3;

  reg [1:0] state, next_state;

  // Shift register to detect pattern 1101
  reg [3:0] shift_reg;

  // Delay register
  reg [3:0] delay;

  // Bit counter for reading delay bits (counts 0 to 3)
  reg [2:0] bit_count;

  // Cycle counter for 1000 clock cycles per count
  reg [9:0] cycle_count;

  // Remaining count for counting down from delay to 0
  reg [3:0] remaining_count;

  // Sequential logic for FSM and registers
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      shift_reg <= 4'b0000;
      delay <= 4'b0000;
      bit_count <= 3'd0;
      cycle_count <= 10'd0;
      remaining_count <= 4'd0;
      count <= 4'bxxxx; // don't care
      counting <= 1'b0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      case(state)
        SEARCH: begin
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'bxxxx; // don't care

          // Shift in new bit
          shift_reg <= {shift_reg[2:0], data};
        end

        READ_DELAY: begin
          counting <= 1'b0;
          done <= 1'b0;

          // Shift in delay bits MSB first into delay register
          // Use bit_count as index, shift delay left and insert data at LSB
          // or alternatively shift delay left and put data at LSB
          // Here, shift delay left and add data at LSB
          delay <= {delay[2:0], data};

          bit_count <= bit_count + 1;
        end

        COUNT: begin
          done <= 1'b0;
          counting <= 1'b1;
          count <= remaining_count;

          if (cycle_count == 10'd999) begin
            cycle_count <= 10'd0;
            if (remaining_count != 4'd0)
              remaining_count <= remaining_count - 1;
            else
              remaining_count <= remaining_count; // stays 0
          end else begin
            cycle_count <= cycle_count + 1;
          end
        end

        DONE: begin
          counting <= 1'b0;
          done <= 1'b1;
          count <= 4'bxxxx; // don't care
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;

    case(state)
      SEARCH: begin
        // Check if pattern 1101 detected in shift_reg (MSB first)
        // pattern is 4'b1101 = binary 13 decimal
        if (shift_reg == 4'b1101)
          next_state = READ_DELAY;
      end

      READ_DELAY: begin
        if (bit_count == 3'd4) begin
          next_state = COUNT;
        end
      end

      COUNT: begin
        // Counting ends when remaining_count == 0 and cycle_count == 999 (last cycle of zero count)
        if ((remaining_count == 4'd0) && (cycle_count == 10'd999))
          next_state = DONE;
      end

      DONE: begin
        // Wait for ack to go high to reset to SEARCH
        if (ack)
          next_state = SEARCH;
      end

      default: next_state = SEARCH;
    endcase
  end

  // Additional sequential logic for initialization and variable updates on transitions
  always @(posedge clk) begin
    if (reset) begin
      bit_count <= 3'd0;
      cycle_count <= 10'd0;
      remaining_count <= 4'd0;
    end else begin
      case(state)
        SEARCH: begin
          bit_count <= 3'd0;
          cycle_count <= 10'd0;
          remaining_count <= 4'd0;
          delay <= 4'd0;
        end

        READ_DELAY: begin
          if (bit_count == 3'd4) begin
            // Initialize counters for counting state on transition
            bit_count <= 3'd0;
            cycle_count <= 10'd0;
            remaining_count <= delay;
          end
        end

        COUNT: begin
          // cycle_count and remaining_count updated in main always block
        end

        DONE: begin
          // Wait for ack to reset FSM, no counters updated here
        end
      endcase
    end
  end

endmodule