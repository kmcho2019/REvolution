module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  // FSM states
  typedef enum logic [1:0] {
    IDLE = 2'b00,
    RECEIVE = 2'b01,
    WAIT_STOP = 2'b10,
    ERROR = 2'b11
  } state_t;

  state_t state, next_state;

  reg [2:0] bit_count;  // counts 0 to 7 for data bits
  reg [7:0] shift_reg;

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      shift_reg <= 8'd0;
      done <= 1'b0;
      out_byte <= 8'd0;
    end else begin
      state <= next_state;
      done <= 1'b0; // default done low unless set below

      case (state)
        IDLE: begin
          bit_count <= 3'd0;
          if (in == 1'b0) begin
            // start bit detected, begin receive
            shift_reg <= 8'd0;
          end
        end
        RECEIVE: begin
          // shift in current bit LSB first
          // As bits come in serially, shift right and insert bit at MSB or shift left and insert at LSB?
          // Protocol sends LSB first, so shift right inserting at MSB or shift left inserting at LSB?
          // We'll shift right and insert new bit at MSB is confusing.
          // Instead, shift left by 1 and insert at LSB.
          shift_reg <= {in, shift_reg[7:1]};
          bit_count <= bit_count + 1'b1;
        end
        WAIT_STOP: begin
          // Check stop bit
          if (in == 1'b1) begin
            // Valid stop bit
            out_byte <= shift_reg;
            done <= 1'b1;
          end
          // else error handled in next_state
        end
        ERROR: begin
          // Waiting for stop bit = 1 to clear error
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      IDLE: begin
        if (!reset && in == 1'b0)
          next_state = RECEIVE;
      end
      RECEIVE: begin
        if (bit_count == 3'd7) begin
          // After 8 data bits collected, next clock will be stop bit
          next_state = WAIT_STOP;
        end
      end
      WAIT_STOP: begin
        if (in == 1'b1) begin
          next_state = IDLE;
        end else begin
          next_state = ERROR;
        end
      end
      ERROR: begin
        if (in == 1'b1) begin
          // stop bit found, recover and go idle
          next_state = IDLE;
        end
      end
    endcase
  end

endmodule