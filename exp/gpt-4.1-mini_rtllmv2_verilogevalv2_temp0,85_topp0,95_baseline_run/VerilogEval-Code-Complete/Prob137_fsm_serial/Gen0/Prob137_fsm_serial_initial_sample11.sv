module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  // States
  typedef enum reg [2:0] {
    IDLE  = 3'd0,
    START = 3'd1,
    DATA  = 3'd2,
    STOP  = 3'd3,
    ERROR = 3'd4
  } state_t;

  state_t state, next_state;

  reg [2:0] bit_cnt;     // Counts data bits received (0 to 7)
  reg [7:0] data_reg;    // Stores the 8-bit data byte, LSB first

  // State transition and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_cnt <= 3'd0;
      data_reg <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      // Default done to 0, set to 1 only when a byte is successfully received
      done <= 1'b0;

      case (state)
        IDLE: begin
          bit_cnt <= 3'd0;
          data_reg <= 8'd0;
        end
        START: begin
          // No action needed here except transition
        end
        DATA: begin
          // Shift in the current bit (LSB first)
          data_reg <= {in, data_reg[7:1]};
          bit_cnt <= bit_cnt + 1'b1;
        end
        STOP: begin
          // done signal will be asserted below if stop bit correct
        end
        ERROR: begin
          // Wait for stop bit (1)
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;

    case (state)
      IDLE: begin
        if (in == 1'b0)          // Start bit detected
          next_state = START;
      end
      START: begin
        // Start bit already detected; move to DATA state
        next_state = DATA;
      end
      DATA: begin
        if (bit_cnt == 3'd7)
          next_state = STOP;    // After 8 bits, go to STOP
        else
          next_state = DATA;    // Continue receiving data bits
      end
      STOP: begin
        if (in == 1'b1) begin
          // Stop bit correct, ready to start next byte
          next_state = IDLE;
        end else begin
          // Stop bit wrong, enter ERROR state to wait for stop bit
          next_state = ERROR;
        end
      end
      ERROR: begin
        // Wait here until stop bit (1) seen
        if (in == 1'b1)
          next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

  // Assert done only for one clock cycle when valid byte received (stop bit correct)
  always @(posedge clk) begin
    if (!reset && state == STOP && in == 1'b1)
      done <= 1'b1;
  end

endmodule