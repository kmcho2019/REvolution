module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  // State encoding
  localparam IDLE      = 3'd0;
  localparam START     = 3'd1;
  localparam DATA      = 3'd2;
  localparam STOP      = 3'd3;
  localparam WAIT_STOP = 3'd4;

  reg [2:0] state, next_state;
  reg [7:0] data_reg;
  reg [2:0] bit_count;

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      data_reg <= 8'd0;
      bit_count <= 3'd0;
      out_byte <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      // Default done deasserted unless asserted below
      done <= 1'b0;

      case(state)
        IDLE: begin
          // Wait for start bit (0)
          if (in == 1'b0) begin
            bit_count <= 3'd0;
            data_reg <= 8'd0;
          end
        end
        START: begin
          // No action on data_reg or bit_count here, next state will start shifting
        end
        DATA: begin
          // Shift in LSB first
          data_reg <= {in, data_reg[7:1]};
          bit_count <= bit_count + 1;
        end
        STOP: begin
          if (in == 1'b1) begin
            // Correct stop bit, output data and signal done
            out_byte <= data_reg;
            done <= 1'b1;
          end
        end
        WAIT_STOP: begin
          // Wait until line is 1 to resync
          // No other actions
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case(state)
      IDLE: begin
        if (in == 1'b0) begin
          next_state = START;
        end
      end
      START: begin
        // Move immediately to DATA to sample bits on next clocks
        next_state = DATA;
      end
      DATA: begin
        if (bit_count == 3'd7) begin
          next_state = STOP;
        end
      end
      STOP: begin
        if (in == 1'b1) begin
          // Stop bit correct, go back to IDLE to wait next byte
          next_state = IDLE;
        end else begin
          // Stop bit incorrect, go to WAIT_STOP to resync
          next_state = WAIT_STOP;
        end
      end
      WAIT_STOP: begin
        if (in == 1'b1) begin
          next_state = IDLE;
        end
      end
      default: next_state = IDLE;
    endcase
  end

endmodule