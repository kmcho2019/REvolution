module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  // States
  localparam IDLE    = 2'd0;
  localparam RECEIVE = 2'd1;
  localparam STOP    = 2'd2;

  reg [1:0] state, next_state;
  reg [2:0] bit_count; // count bits received (0 to 7)
  reg [7:0] shift_reg;

  // State transitions
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      shift_reg <= 8'd0;
      out_byte <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      case (state)
        IDLE: begin
          done <= 1'b0;
          bit_count <= 3'd0;
          shift_reg <= 8'd0;
          // Wait for start bit (0)
          if (in == 1'b0) begin
            bit_count <= 3'd0;
          end
        end

        RECEIVE: begin
          // Shift in the incoming bit LSB first
          shift_reg <= {in, shift_reg[7:1]};
          bit_count <= bit_count + 1'b1;
          done <= 1'b0;
        end

        STOP: begin
          if (in == 1'b1) begin
            // Valid stop bit, output data and assert done
            out_byte <= shift_reg;
            done <= 1'b1;
          end else begin
            // Invalid stop bit, do not assert done, wait for stop bit
            done <= 1'b0;
          end
        end

        default: begin
          done <= 1'b0;
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
        if (in == 1'b0) begin
          next_state = RECEIVE;
        end
      end

      RECEIVE: begin
        // After receiving 8 bits, move to STOP
        if (bit_count == 3'd7) begin
          next_state = STOP;
        end
      end

      STOP: begin
        // If stop bit 1 detected, go back to IDLE for next byte
        if (in == 1'b1) begin
          next_state = IDLE;
        end else begin
          // Remain in STOP state until stop bit is 1
          next_state = STOP;
        end
      end

      default: next_state = IDLE;
    endcase
  end

endmodule