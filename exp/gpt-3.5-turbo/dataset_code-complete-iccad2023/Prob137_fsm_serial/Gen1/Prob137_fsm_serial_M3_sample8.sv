module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  reg [1:0] state, next_state;
  parameter IDLE = 2'b00, START_BIT = 2'b01, DATA_BITS = 2'b10, STOP_BIT = 2'b11;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      done <= 0;
    end
    else begin
      state <= next_state;
    end
  end

  always @* begin
    next_state = state;

    case (state)
      IDLE:
        if (in == 1'b0) begin
          next_state = START_BIT;
        end
      START_BIT:
        begin
          // Wait for 8 data bits
          next_state = DATA_BITS;
        end
      DATA_BITS:
        begin
          // Wait for 1 stop bit
          next_state = STOP_BIT;
        end
      STOP_BIT:
        begin
          if (in == 1'b1) begin
            next_state = IDLE;
            done = 1;
          end else begin
            next_state = STOP_BIT;
          end
        end
    endcase
  end

endmodule