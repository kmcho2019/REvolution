module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  // State encoding
  localparam IDLE      = 2'd0;
  localparam DATA      = 2'd1;
  localparam STOP      = 2'd2;
  localparam WAIT_STOP = 2'd3;

  reg [1:0] state, next_state;
  reg [3:0] bit_count;
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
      done <= 1'b0; // default done low each cycle, set in STOP when valid stop bit detected

      case (state)
        IDLE: begin
          bit_count <= 0;
          shift_reg <= 8'b0;
          if (in == 1'b0) // start bit detected
            ; // wait for next state logic
        end

        DATA: begin
          // Shift in data bit (LSB first)
          shift_reg <= {in, shift_reg[7:1]};
          bit_count <= bit_count + 1;
        end

        STOP: begin
          if (in == 1'b1) begin
            // Valid stop bit
            out_byte <= shift_reg;
            done <= 1'b1;
          end
          // else invalid stop bit, done stays 0
        end

        WAIT_STOP: begin
          // Wait until in==1 to find stop bit
          // nothing else to do here
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
        if (bit_count == 4'd7)
          next_state = STOP;
        else
          next_state = DATA;
      end

      STOP: begin
        if (in == 1'b1)
          next_state = IDLE; // valid stop bit, ready for next byte
        else
          next_state = WAIT_STOP; // invalid stop bit, wait until valid stop bit seen
      end

      WAIT_STOP: begin
        if (in == 1'b1)
          next_state = IDLE;
      end

      default: next_state = IDLE;
    endcase
  end

endmodule