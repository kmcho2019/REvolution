module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  // States
  typedef enum logic [1:0] {
    IDLE = 2'd0,
    RECEIVE = 2'd1,
    STOP_WAIT = 2'd2
  } state_t;

  state_t state, next_state;
  reg [3:0] bit_count; // 4 bits to count up to 8
  reg [7:0] data;      // storage for received data bits (optional)

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 0;
      done <= 0;
    end else begin
      state <= next_state;
      done <= 0; // default no done pulse

      case(state)
        IDLE: begin
          bit_count <= 0;
          if (in == 1'b0) begin
            // start bit detected
            bit_count <= 0;
          end
        end
        RECEIVE: begin
          // shift in data bits LSB first
          data[bit_count] <= in;
          bit_count <= bit_count + 1;
        end
        STOP_WAIT: begin
          // waiting for stop bit 1 to appear
          // no data or bit_count changes here
        end
      endcase
    end
  end

  // Next state logic and done signal
  always @(*) begin
    next_state = state;
    done = 0;

    case(state)
      IDLE: begin
        if (in == 1'b0) // start bit detected
          next_state = RECEIVE;
      end

      RECEIVE: begin
        if (bit_count == 8) begin
          // After receiving 8 bits, expect stop bit
          if (in == 1'b1) begin
            // Stop bit correct
            next_state = IDLE;
            done = 1;
          end else begin
            // Stop bit incorrect
            next_state = STOP_WAIT;
          end
        end
      end

      STOP_WAIT: begin
        if (in == 1'b1) begin
          // Stop bit found, go to IDLE to start next byte
          next_state = IDLE;
        end
      end
    endcase
  end

endmodule