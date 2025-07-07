module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  // State encoding
  typedef enum reg [2:0] {
    IDLE = 3'd0,
    START = 3'd1,
    DATA = 3'd2,
    STOP = 3'd3,
    WAIT_STOP = 3'd4
  } state_t;

  state_t state, next_state;
  reg [2:0] bit_count; // counts 0 to 7 for 8 data bits

  // Sequential logic for state and bit_count
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      done <= 1'b0; // default done low, asserted only in STOP state when correct stop bit

      if (state == DATA)
        bit_count <= bit_count + 3'd1;
      else
        bit_count <= 3'd0;
    end
  end

  // Combinational logic for next state
  always @(*) begin
    next_state = state;
    case (state)
      IDLE: begin
        // Wait for start bit (0)
        if (in == 1'b0)
          next_state = START;
      end

      START: begin
        // After detecting start bit, move to DATA to receive 8 bits
        next_state = DATA;
      end

      DATA: begin
        if (bit_count == 3'd7) // after receiving 8th bit
          next_state = STOP;
        else
          next_state = DATA;
      end

      STOP: begin
        if (in == 1'b1) begin
          // Correct stop bit, done asserted for one cycle
          next_state = IDLE;
        end else begin
          // Incorrect stop bit, wait for stop bit
          next_state = WAIT_STOP;
        end
      end

      WAIT_STOP: begin
        // Wait until stop bit (1) is seen
        if (in == 1'b1)
          next_state = IDLE;
        else
          next_state = WAIT_STOP;
      end

      default: next_state = IDLE;
    endcase
  end

  // Assert done when in STOP state and stop bit is correct
  always @(posedge clk) begin
    if (!reset && state == STOP && in == 1'b1)
      done <= 1'b1;
  end

endmodule