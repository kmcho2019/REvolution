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
    ERROR = 3'd4
  } state_t;

  state_t state, next_state;

  reg [3:0] bit_count; // to count 8 data bits

  // Sequential logic: state and bit_count update
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 4'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      done <= 1'b0; // default done low unless assigned in STOP state

      if (state == DATA)
        bit_count <= bit_count + 1'b1;
      else
        bit_count <= 4'd0;

      if (state == STOP) begin
        if (in == 1'b1) begin
          done <= 1'b1; // byte received correctly
        end
      end
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      IDLE: begin
        if (in == 1'b0) // start bit detected
          next_state = START;
      end

      START: begin
        // Move to DATA on next clock cycle
        next_state = DATA;
      end

      DATA: begin
        if (bit_count == 4'd7) // after receiving 8 bits total (0..7)
          next_state = STOP;
      end

      STOP: begin
        if (in == 1'b1)
          next_state = IDLE; // valid stop bit, ready for next byte
        else
          next_state = ERROR; // invalid stop bit, go to error
      end

      ERROR: begin
        // Wait until input line is high (stop bit)
        if (in == 1'b1)
          next_state = IDLE;
      end

      default: next_state = IDLE;
    endcase
  end

endmodule