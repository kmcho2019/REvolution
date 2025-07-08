module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  // State encoding
  typedef enum logic [2:0] {
    IDLE = 3'b000,
    START = 3'b001,
    DATA = 3'b010,
    STOP = 3'b011,
    WAIT_STOP = 3'b100
  } state_t;

  state_t state, next_state;

  reg [3:0] bit_count; // count 0..7 for 8 data bits

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 0;
      done <= 0;
    end else begin
      state <= next_state;

      // Default done low, set high only in STOP state with valid stop bit
      done <= 0;

      case (state)
        IDLE: begin
          bit_count <= 0;
        end
        START: begin
          bit_count <= 0;
        end
        DATA: begin
          if (bit_count < 8)
            bit_count <= bit_count + 1;
        end
        STOP: begin
          // done will be set high combinationally in next_state logic below
          bit_count <= 0;
        end
        WAIT_STOP: begin
          // wait for in==1 before returning to IDLE
          bit_count <= 0;
        end
      endcase
    end
  end

  // Next state logic and done signal
  always @(*) begin
    next_state = state;
    done = 0;
    case (state)
      IDLE: begin
        if (in == 0) // start bit detected
          next_state = START;
        else
          next_state = IDLE;
      end
      START: begin
        // start bit lasts one cycle only, move to DATA
        next_state = DATA;
      end
      DATA: begin
        if (bit_count == 7) // last data bit received this cycle
          next_state = STOP;
        else
          next_state = DATA;
      end
      STOP: begin
        if (in == 1) begin
          done = 1;  // valid stop bit, byte received
          next_state = IDLE;
        end else begin
          // stop bit invalid, go to wait_stop state
          next_state = WAIT_STOP;
        end
      end
      WAIT_STOP: begin
        if (in == 1)
          next_state = IDLE;
        else
          next_state = WAIT_STOP;
      end
      default: next_state = IDLE;
    endcase
  end

endmodule