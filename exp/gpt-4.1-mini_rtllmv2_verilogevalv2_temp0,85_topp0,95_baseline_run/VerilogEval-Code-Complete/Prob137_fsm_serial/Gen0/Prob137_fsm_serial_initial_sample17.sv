module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  // State encoding
  typedef enum reg [2:0] {
    IDLE  = 3'b000,
    START = 3'b001,
    DATA  = 3'b010,
    STOP  = 3'b011,
    ERROR = 3'b100
  } state_t;
  
  state_t state, next_state;

  reg [2:0] bit_count;   // Counts bits received (0 to 7 for data)
  reg [7:0] data_reg;    // Store received data bits (optional, not output here)

  // State transition logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      data_reg <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      done <= 1'b0; // Default done low

      case (state)
        IDLE: begin
          bit_count <= 3'd0;
          data_reg <= 8'd0;
          // Wait for start bit 0
          // transition handled in next_state logic
        end

        START: begin
          // Confirm start bit == 0
          // transition handled in next_state logic
        end

        DATA: begin
          // Shift in data bit (LSB first)
          data_reg <= {in, data_reg[7:1]};
          bit_count <= bit_count + 1;
        end

        STOP: begin
          // Check stop bit = 1, done asserted if correct
          if (in == 1'b1)
            done <= 1'b1;
        end

        ERROR: begin
          // Wait for in == 1 (stop bit) to recover
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      IDLE: begin
        if (in == 1'b0)      // start bit detected
          next_state = START;
        else
          next_state = IDLE;
      end

      START: begin
        // Confirm start bit is still 0 (sampled at clock edge)
        if (in == 1'b0)
          next_state = DATA;
        else
          next_state = IDLE;  // False start bit, go back
      end

      DATA: begin
        if (bit_count == 3'd7) 
          next_state = STOP;
        else
          next_state = DATA;
      end

      STOP: begin
        if (in == 1'b1)
          next_state = IDLE;
        else
          next_state = ERROR;
      end

      ERROR: begin
        if (in == 1'b1)  // Wait for stop bit to recover
          next_state = IDLE;
        else
          next_state = ERROR;
      end

      default: next_state = IDLE;
    endcase
  end

endmodule