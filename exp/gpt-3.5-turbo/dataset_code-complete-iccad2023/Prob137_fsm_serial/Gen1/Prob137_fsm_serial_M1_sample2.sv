module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  reg [2:0] state, next_state;
  reg [2:0] count;

  parameter IDLE = 3'b000, START_BIT = 3'b001, DATA_BITS = 3'b010, WAIT_STOP = 3'b011;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      count <= 3'b0;
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
          next_state = DATA_BITS;
        end
      DATA_BITS:
        begin
          if (count == 3'b111) begin
            next_state = WAIT_STOP;
            count <= 3'b0;
          end else begin
            count <= count + 1;
          end
        end
      WAIT_STOP:
        begin
          if (in == 1'b1) begin
            next_state = IDLE;
            done = 1;
          end else begin
            next_state = WAIT_STOP;
          end
        end
    endcase
  end

endmodule