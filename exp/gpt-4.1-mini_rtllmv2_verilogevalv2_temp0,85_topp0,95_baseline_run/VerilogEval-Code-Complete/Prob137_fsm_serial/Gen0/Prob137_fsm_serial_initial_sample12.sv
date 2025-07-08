module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  typedef enum reg [2:0] {
    IDLE = 3'd0,
    START = 3'd1,
    DATA = 3'd2,
    STOP = 3'd3,
    WAIT_STOP = 3'd4
  } state_t;

  state_t state, next_state;
  reg [2:0] bit_count;    // To count 8 data bits
  reg [7:0] data_reg;     // To store received data bits

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      data_reg <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      // Default done low, will set high for one clk cycle when byte received
      done <= 1'b0;

      case(state)
        START: begin
          // No data shifts here, just confirm start bit (already detected)
          bit_count <= 3'd0;
          data_reg <= 8'd0;
        end

        DATA: begin
          // Shift in data bits LSB first
          data_reg <= {in, data_reg[7:1]};
          bit_count <= bit_count + 1'b1;
        end

        default: begin
          // no action on others
        end
      endcase
    end
  end

  // Next state logic and done signal generation
  always @(*) begin
    next_state = state;
    done = 1'b0;

    case(state)
      IDLE: begin
        if (in == 1'b0) // start bit detected (line went from idle 1 to 0)
          next_state = START;
      end

      START: begin
        // Confirm start bit is still 0 (should be stable)
        if (in == 1'b0)
          next_state = DATA;
        else
          next_state = IDLE; // false start, return to idle
      end

      DATA: begin
        if (bit_count == 3'd7) // last data bit being received this cycle
          next_state = STOP;
        else
          next_state = DATA;
      end

      STOP: begin
        if (in == 1'b1) begin
          // Correct stop bit
          done = 1'b1;
          next_state = IDLE;
        end else begin
          // Stop bit incorrect, wait until line goes high (stop bit)
          next_state = WAIT_STOP;
        end
      end

      WAIT_STOP: begin
        if (in == 1'b1)
          next_state = IDLE;
        else
          next_state = WAIT_STOP;
      end

      default: next_state = IDLE;
    endcase
  end

endmodule