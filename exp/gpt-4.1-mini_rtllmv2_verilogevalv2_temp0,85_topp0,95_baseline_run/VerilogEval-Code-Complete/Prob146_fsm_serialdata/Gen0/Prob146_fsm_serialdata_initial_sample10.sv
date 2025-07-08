module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  typedef enum logic [1:0] {
    IDLE = 2'b00,
    RECEIVE = 2'b01,
    STOP = 2'b10,
    WAIT_STOP = 2'b11
  } state_t;

  state_t state, next_state;

  reg [3:0] bit_count; // count 0 to 7 for data bits
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

      done <= 1'b0; // default no done

      case (state)
        IDLE: begin
          bit_count <= 0;
          shift_reg <= 8'b0;
          // wait for start bit (in == 0)
          // no other registers updated here
        end
        RECEIVE: begin
          // shift in data bit LSB first
          // On each clock, sample 'in' and shift into shift_reg
          shift_reg <= {in, shift_reg[7:1]};
          bit_count <= bit_count + 1;
        end
        STOP: begin
          // Check stop bit
          if (in == 1'b1) begin
            out_byte <= shift_reg;
            done <= 1'b1;
          end
          // bit_count stays 0
        end
        WAIT_STOP: begin
          // just wait for in == 1 stop bit to resume
          // no shift or count changes
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      IDLE: begin
        if (in == 1'b0) // start bit detected
          next_state = RECEIVE;
        else
          next_state = IDLE;
      end
      RECEIVE: begin
        if (bit_count == 4'd7) // last data bit just shifted in this clock
          next_state = STOP;
        else
          next_state = RECEIVE;
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
        else
          next_state = WAIT_STOP;
      end
    endcase
  end

endmodule