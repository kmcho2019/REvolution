module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  // States encoding
  localparam IDLE   = 3'd0;
  localparam START  = 3'd1;
  localparam DATA   = 3'd2;
  localparam STOP   = 3'd3;
  localparam ERROR  = 3'd4;

  reg [2:0] state, next_state;
  reg [3:0] bit_count;  // 0 to 7 for 8 bits
  reg [7:0] data_reg;

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 0;
      done <= 0;
      data_reg <= 0;
    end else begin
      state <= next_state;
      done <= 0; // default done low
      case (state)
        IDLE: begin
          bit_count <= 0;
          data_reg <= 0;
        end
        START: begin
          // no counting yet
        end
        DATA: begin
          // shift in bit
          data_reg <= {in, data_reg[7:1]}; // LSB first: shift in at MSB, shift right
          bit_count <= bit_count + 1;
        end
        STOP: begin
          // done will be asserted below if stop bit correct
        end
        ERROR: begin
          // wait for in=1 before next IDLE
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
          next_state = START;
      end
      START: begin
        // Confirm start bit is still 0
        if (in == 1'b0)
          next_state = DATA;
        else
          next_state = IDLE; // false start, back to idle
      end
      DATA: begin
        if (bit_count == 4'd7) // after receiving 8 bits (count 0..7)
          next_state = STOP;
        else
          next_state = DATA;
      end
      STOP: begin
        if (in == 1'b1) begin
          // stop bit correct
          done = 1'b1;
          next_state = IDLE;
        end else begin
          // stop bit incorrect, go to error recovery
          next_state = ERROR;
        end
      end
      ERROR: begin
        if (in == 1'b1)
          next_state = IDLE;
        else
          next_state = ERROR;
      end
    endcase
  end

endmodule