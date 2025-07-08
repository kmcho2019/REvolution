module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  // States encoding
  typedef enum reg [2:0] {
    IDLE = 3'd0,
    START = 3'd1,
    DATA = 3'd2,
    STOP = 3'd3,
    ERROR_WAIT = 3'd4
  } state_t;

  reg [2:0] state, next_state;
  reg [3:0] bit_count; // to count 8 data bits
  reg [7:0] data_reg;

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 4'd0;
      data_reg <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      // Clear done except when set explicitly
      done <= 1'b0;

      case (state)
        IDLE: begin
          bit_count <= 4'd0;
          data_reg <= 8'd0;
        end
        START: begin
          // Nothing special here
        end
        DATA: begin
          if (next_state == DATA) begin
            // Shift in data bit at LSB first
            data_reg <= {in, data_reg[7:1]};
            bit_count <= bit_count + 1;
          end
        end
        STOP: begin
          if (in == 1'b1) begin
            done <= 1'b1;
          end
        end
        ERROR_WAIT: begin
          // Wait for stop bit 1, no other action needed
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      IDLE: begin
        // Wait for start bit 0
        if (in == 1'b0)
          next_state = START;
        else
          next_state = IDLE;
      end
      START: begin
        // After seeing start bit, move to DATA to read bits
        // We sample on next clock cycle, so just go to DATA
        next_state = DATA;
      end
      DATA: begin
        if (bit_count == 4'd8) begin
          // All data bits received, next expect stop bit
          next_state = STOP;
        end else begin
          next_state = DATA;
        end
      end
      STOP: begin
        if (in == 1'b1) begin
          // Correct stop bit, go back to IDLE for next byte
          next_state = IDLE;
        end else begin
          // Stop bit incorrect, enter error wait
          next_state = ERROR_WAIT;
        end
      end
      ERROR_WAIT: begin
        if (in == 1'b1) begin
          // Found stop bit to resync
          next_state = IDLE;
        end else begin
          next_state = ERROR_WAIT;
        end
      end
      default: next_state = IDLE;
    endcase
  end

endmodule