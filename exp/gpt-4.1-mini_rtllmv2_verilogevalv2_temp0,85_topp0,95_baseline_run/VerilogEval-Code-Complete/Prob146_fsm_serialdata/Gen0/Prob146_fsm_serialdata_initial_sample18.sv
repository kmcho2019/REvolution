module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  typedef enum logic [1:0] {
    IDLE = 2'b00,
    DATA = 2'b01,
    STOP = 2'b10,
    WAIT_STOP = 2'b11
  } state_t;

  state_t state, next_state;
  reg [2:0] bit_count;
  reg [7:0] shift_reg;

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 3'd0;
      shift_reg <= 8'd0;
      out_byte <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      // Default done low unless set below
      done <= 1'b0;

      case (state)
        IDLE: begin
          if (in == 1'b0) begin
            // Start bit detected
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
          end
        end

        DATA: begin
          // Shift in data bits LSB first
          shift_reg <= {in, shift_reg[7:1]};
          bit_count <= bit_count + 3'd1;
        end

        STOP: begin
          // If stop bit correct (in=1), output byte and assert done
          if (in == 1'b1) begin
            out_byte <= shift_reg;
            done <= 1'b1;
          end
        end

        WAIT_STOP: begin
          // Wait until line goes high (stop bit)
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      IDLE: begin
        if (in == 1'b0)
          next_state = DATA;
      end

      DATA: begin
        if (bit_count == 3'd7)
          next_state = STOP;
      end

      STOP: begin
        if (in == 1'b1)
          next_state = IDLE;
        else
          next_state = WAIT_STOP;
      end

      WAIT_STOP: begin
        if (in == 1'b1)
          next_state = IDLE;
      end
    endcase
  end

endmodule