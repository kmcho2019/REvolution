module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  typedef enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP,
    ERROR
  } state_t;

  state_t state, next_state;

  reg [3:0] bit_cnt; // count 0 to 7 for data bits
  reg [7:0] data_reg; // store received data bits

  // Sequential state and counters update
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_cnt <= 0;
      data_reg <= 0;
      done <= 0;
    end else begin
      state <= next_state;

      done <= 0; // default done low, pulse high only on stop bit success

      case (state)
        IDLE: begin
          bit_cnt <= 0;
          data_reg <= 0;
        end
        START: begin
          bit_cnt <= 0;
          data_reg <= 0;
        end
        DATA: begin
          // Shift in LSB first
          data_reg <= {in, data_reg[7:1]};
          bit_cnt <= bit_cnt + 1;
        end
        STOP: begin
          // done is set in next_state logic
        end
        ERROR: begin
          // wait for stop bit 1 before returning to IDLE
        end
      endcase
    end
  end

  // Combinational logic for next state and done signal
  always @(*) begin
    next_state = state;
    done = 0;

    case (state)
      IDLE: begin
        // line idle high; start bit = 0 means start receive
        if (in == 0) next_state = START;
      end
      START: begin
        // We already confirmed start bit == 0 in IDLE
        // Next go to DATA to receive 8 bits
        next_state = DATA;
      end
      DATA: begin
        if (bit_cnt == 8) begin
          // All 8 bits received, check stop bit next
          next_state = STOP;
        end else begin
          next_state = DATA;
        end
      end
      STOP: begin
        if (in == 1) begin
          done = 1;
          next_state = IDLE;
        end else begin
          // stop bit error
          next_state = ERROR;
        end
      end
      ERROR: begin
        // Wait until line is 1 (stop bit) to recover
        if (in == 1) next_state = IDLE;
        else next_state = ERROR;
      end
    endcase
  end

endmodule