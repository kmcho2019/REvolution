module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  typedef enum reg [2:0] {
    IDLE       = 3'b000,
    START_BIT  = 3'b001,
    DATA_BITS  = 3'b010,
    STOP_BIT   = 3'b011,
    ERROR_WAIT = 3'b100
  } state_t;

  reg [2:0] state, next_state;
  reg [2:0] bit_count;  // counts 0 to 7 for data bits
  reg [7:0] data_shift; // stores received data bits (optional, not output here)

  // Synchronous state and counters update
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      data_shift <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      done <= 1'b0; // default no done output

      case(state)
        IDLE: begin
          bit_count <= 3'd0;
          data_shift <= 8'd0;
          // wait for start bit in next_state logic
        end

        START_BIT: begin
          // no shift, just move next cycle
          bit_count <= 3'd0;
          data_shift <= 8'd0;
        end

        DATA_BITS: begin
          // shift in LSB first
          data_shift <= {in, data_shift[7:1]};
          bit_count <= bit_count + 1;
        end

        STOP_BIT: begin
          if (in == 1'b1) begin
            done <= 1'b1; // successful reception
          end
        end

        ERROR_WAIT: begin
          // wait until in==1 to return to IDLE
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case(state)
      IDLE: begin
        if (in == 1'b0)
          next_state = START_BIT; // detected start bit
      end

      START_BIT: begin
        next_state = DATA_BITS;
      end

      DATA_BITS: begin
        if (bit_count == 3'd7)
          next_state = STOP_BIT;
      end

      STOP_BIT: begin
        if (in == 1'b1)
          next_state = IDLE;      // correct stop bit, next byte
        else
          next_state = ERROR_WAIT; // bad stop bit, wait for stop bit
      end

      ERROR_WAIT: begin
        if (in == 1'b1)
          next_state = IDLE; // found stop bit, back to idle
      end
    endcase
  end

endmodule