module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  typedef enum logic [2:0] {
    IDLE = 3'b000,
    START = 3'b001,
    DATA = 3'b010,
    STOP = 3'b011,
    WAIT_STOP = 3'b100
  } state_t;
  
  state_t state, next_state;
  reg [2:0] bit_count; // counts 0 to 7 for 8 bits

  // Sequential state transition and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      done <= 1'b0; // default done low, asserted only at correct stop bit

      case(state)
        IDLE: begin
          bit_count <= 3'd0;
        end
        START: begin
          bit_count <= 3'd0;
        end
        DATA: begin
          // count bits
          bit_count <= bit_count + 1'b1;
        end
        STOP: begin
          // done asserted here if stop bit correct, bit_count reset handled in IDLE
        end
        WAIT_STOP: begin
          // no bit_count increment
        end
      endcase
    end
  end

  // Combinational next state logic and done signal assertion
  always @(*) begin
    next_state = state;
    done = 1'b0;
    case(state)
      IDLE: begin
        if (in == 1'b0) // detect start bit
          next_state = START;
        else
          next_state = IDLE;
      end
      START: begin
        // We are at the start bit, move to data to sample bits
        next_state = DATA;
      end
      DATA: begin
        if (bit_count == 3'd7) begin
          next_state = STOP;
        end else begin
          next_state = DATA;
        end
      end
      STOP: begin
        if (in == 1'b1) begin
          done = 1'b1; // correct stop bit received
          next_state = IDLE;
        end else begin
          next_state = WAIT_STOP; // incorrect stop bit, wait for next stop bit
        end
      end
      WAIT_STOP: begin
        if (in == 1'b1)
          next_state = IDLE; // resync on stop bit
        else
          next_state = WAIT_STOP;
      end
      default: next_state = IDLE;
    endcase
  end

endmodule