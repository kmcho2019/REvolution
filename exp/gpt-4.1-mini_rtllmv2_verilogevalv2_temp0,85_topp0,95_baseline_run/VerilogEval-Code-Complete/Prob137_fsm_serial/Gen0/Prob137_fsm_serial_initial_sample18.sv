module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  typedef enum reg [2:0] {
    IDLE = 3'b000,
    START = 3'b001,
    DATA = 3'b010,
    STOP = 3'b011,
    ERROR = 3'b100
  } state_t;

  state_t state, next_state;

  reg [2:0] bit_count; // Count from 0 to 7 for data bits

  // Sequential logic for state and counters
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      done <= 1'b0; // default done low

      if (state == DATA)
        bit_count <= bit_count + 3'd1;
      else
        bit_count <= 3'd0;

      if (state == STOP && in == 1'b1) begin
        done <= 1'b1;
      end
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      IDLE: begin
        if (in == 1'b0) // start bit detected
          next_state = START;
        else
          next_state = IDLE;
      end
      START: begin
        // After start bit, move to DATA state to read data bits
        next_state = DATA;
      end
      DATA: begin
        if (bit_count == 3'd7) // after last data bit received
          next_state = STOP;
        else
          next_state = DATA;
      end
      STOP: begin
        if (in == 1'b1) // valid stop bit
          next_state = IDLE;
        else
          next_state = ERROR;
      end
      ERROR: begin
        if (in == 1'b1) // wait for stop bit to appear
          next_state = IDLE;
        else
          next_state = ERROR;
      end
      default: next_state = IDLE;
    endcase
  end

endmodule