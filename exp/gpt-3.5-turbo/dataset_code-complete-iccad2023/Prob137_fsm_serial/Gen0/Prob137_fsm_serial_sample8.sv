module TopModule (
  input clk,
  input in,
  input reset,
  output done
);

  reg [2:0] state, next_state;
  parameter IDLE = 3'b000, START_BIT = 3'b001, DATA_BITS = 3'b010, STOP_BIT = 3'b011;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end
    else begin
      state <= next_state;
    end
  end

  always @* begin
    next_state = state;
    done = 0;

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