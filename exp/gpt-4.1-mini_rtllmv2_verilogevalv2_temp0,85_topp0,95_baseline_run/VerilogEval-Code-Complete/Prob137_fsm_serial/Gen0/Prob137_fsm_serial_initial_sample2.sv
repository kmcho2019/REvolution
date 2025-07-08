module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  typedef enum reg [2:0] {
    IDLE  = 3'd0,
    START = 3'd1,
    DATA  = 3'd2,
    STOP  = 3'd3,
    ERROR = 3'd4
  } state_t;

  state_t state, next_state;
  reg [3:0] bit_count;      // counts 0 to 7 for data bits
  reg [7:0] data_reg;       // store received data bits (not required for output, but useful)
  
  // State transition and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 0;
      data_reg <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      
      // Default done pulse low, pulse high only one clock when done
      done <= 1'b0;

      case(state)
        IDLE: begin
          bit_count <= 0;
          data_reg <= 8'd0;
          // Wait for start bit (0)
        end

        START: begin
          // Capture first data bit at next cycle
        end

        DATA: begin
          // Shift in data bits LSB first
          data_reg <= {in, data_reg[7:1]};
          bit_count <= bit_count + 1;
        end

        STOP: begin
          // Check stop bit correctness
          if (in == 1'b1) begin
            done <= 1'b1; // Byte received correctly
          end
        end

        ERROR: begin
          // Wait until we see stop bit to return to IDLE
        end

      endcase
    end
  end

  // Next state combinational logic
  always @(*) begin
    next_state = state;
    case(state)
      IDLE: begin
        if (in == 1'b0) // Start bit detected
          next_state = START;
      end

      START: begin
        // Immediately go to DATA to sample data bits at next clk cycle
        next_state = DATA;
      end

      DATA: begin
        if (bit_count == 4'd7)
          next_state = STOP;
      end

      STOP: begin
        if (in == 1'b1)
          next_state = IDLE;  // Correct stop bit, ready for next byte
        else
          next_state = ERROR; // Invalid stop bit
      end

      ERROR: begin
        if (in == 1'b1)
          next_state = IDLE; // Wait for stop bit to resync
      end

      default: next_state = IDLE;
    endcase
  end

endmodule