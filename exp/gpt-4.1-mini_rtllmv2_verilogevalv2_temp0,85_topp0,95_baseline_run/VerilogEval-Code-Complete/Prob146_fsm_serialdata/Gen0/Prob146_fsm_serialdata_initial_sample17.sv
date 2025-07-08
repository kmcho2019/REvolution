module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  typedef enum logic [1:0] {
    IDLE = 2'd0,
    RECEIVE = 2'd1,
    STOP = 2'd2
  } state_t;

  state_t state, next_state;

  reg [7:0] shift_reg;
  reg [2:0] bit_count; // count 0 to 7 for data bits

  // Sequential logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      shift_reg <= 8'd0;
      bit_count <= 3'd0;
      out_byte <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      done <= 1'b0; // default done low
      case(state)
        IDLE: begin
          // Wait for start bit (0)
          if (in == 1'b0) begin
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
          end
        end

        RECEIVE: begin
          // Shift in LSB first
          shift_reg <= {in, shift_reg[7:1]};
          bit_count <= bit_count + 1'b1;
        end

        STOP: begin
          if (in == 1'b1) begin
            out_byte <= shift_reg;
            done <= 1'b1; // Indicate byte received
          end
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case(state)
      IDLE: begin
        if (in == 1'b0) // Start bit detected
          next_state = RECEIVE;
      end

      RECEIVE: begin
        if (bit_count == 3'd7)
          next_state = STOP;
        else
          next_state = RECEIVE;
      end

      STOP: begin
        if (in == 1'b1) // Stop bit correct, return to IDLE
          next_state = IDLE;
        else
          next_state = STOP; // Wait until stop bit '1' received
      end
    endcase
  end

endmodule