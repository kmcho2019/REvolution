module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  // State encoding
  typedef enum logic [1:0] {
    IDLE  = 2'b00,
    DATA  = 2'b01,
    STOP  = 2'b10,
    ERROR = 2'b11
  } state_t;

  state_t state, next_state;

  reg [3:0] bit_count;  // counts 0 to 7 for data bits
  reg [7:0] shift_reg;

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 0;
      shift_reg <= 8'b0;
      out_byte <= 8'b0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      // Default done to 0; done is asserted only 1 cycle
      done <= 1'b0;

      case (state)
        IDLE: begin
          bit_count <= 0;
          shift_reg <= 8'b0;
          if (in == 1'b0) begin
            // start bit detected, next cycle read first data bit
            bit_count <= 0;
          end
        end
        DATA: begin
          // shift in data LSB first
          shift_reg <= {in, shift_reg[7:1]};
          bit_count <= bit_count + 1;
        end
        STOP: begin
          if (in == 1'b1) begin
            // stop bit correct
            out_byte <= shift_reg;
            done <= 1'b1;
          end
        end
        ERROR: begin
          // wait until line is 1 before going to IDLE
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      IDLE: begin
        if (~reset) begin
          if (in == 1'b0) // start bit detected
            next_state = DATA;
          else
            next_state = IDLE;
        end else begin
          next_state = IDLE;
        end
      end
      DATA: begin
        if (bit_count == 4'd7) begin
          next_state = STOP;
        end else begin
          next_state = DATA;
        end
      end
      STOP: begin
        if (in == 1'b1)
          next_state = IDLE;
        else
          next_state = ERROR;
      end
      ERROR: begin
        if (in == 1'b1) // wait for stop bit to resync
          next_state = IDLE;
        else
          next_state = ERROR;
      end
    endcase
  end

endmodule