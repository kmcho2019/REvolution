module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  typedef enum reg [2:0] {
    IDLE = 3'd0,
    START = 3'd1,
    DATA = 3'd2,
    STOP = 3'd3,
    ERROR_WAIT = 3'd4
  } state_t;

  state_t state, next_state;
  reg [7:0] data_reg;
  reg [3:0] bit_count;

  // State transition and outputs
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      data_reg <= 8'b0;
      bit_count <= 4'd0;
      out_byte <= 8'b0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      case (state)
        IDLE: begin
          done <= 1'b0;
          data_reg <= 8'b0;
          bit_count <= 4'd0;
        end

        START: begin
          // Nothing special on clock edge here; just waiting for next bit in DATA state.
          done <= 1'b0;
        end

        DATA: begin
          // Shift in bit, least significant bit first
          data_reg <= {in, data_reg[7:1]};
          bit_count <= bit_count + 1;
          done <= 1'b0;
        end

        STOP: begin
          done <= 1'b0;
          if (in == 1'b1) begin
            // Correct stop bit
            out_byte <= data_reg;
            done <= 1'b1;
          end
        end

        ERROR_WAIT: begin
          done <= 1'b0;
        end

        default: begin
          done <= 1'b0;
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      IDLE: begin
        if (in == 1'b0)
          next_state = START;
        else
          next_state = IDLE;
      end

      START: begin
        // After confirming start bit, go to DATA state to collect 8 bits
        next_state = DATA;
      end

      DATA: begin
        if (bit_count == 4'd7) // After last bit received, go to STOP
          next_state = STOP;
        else
          next_state = DATA;
      end

      STOP: begin
        if (in == 1'b1)
          next_state = IDLE;
        else
          next_state = ERROR_WAIT;
      end

      ERROR_WAIT: begin
        if (in == 1'b1)
          next_state = IDLE;
        else
          next_state = ERROR_WAIT;
      end

      default: next_state = IDLE;
    endcase
  end

endmodule