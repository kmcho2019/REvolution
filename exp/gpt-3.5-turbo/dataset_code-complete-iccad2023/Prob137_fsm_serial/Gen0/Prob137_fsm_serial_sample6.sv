module TopModule (
  input clk,
  input in,
  input reset,
  output done
);

  enum logic [2:0] states = {IDLE, START_BIT, DATA_BITS, STOP_BIT};
  logic [2:0] state, next_state;
  logic [7:0] data;
  logic [2:0] count;

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      count <= 0;
      data <= 8'b0;
    end
    else begin
      state <= next_state;
      count <= count + 1;
    end
  end

  always_comb begin
    done = (state == STOP_BIT) ? 1'b1 : 1'b0;
  end

  always_comb begin
    case(state)
      IDLE: begin
        if (in == 1) begin
          next_state = START_BIT;
          count = 0;
        end
        else begin
          next_state = IDLE;
        end
      end

      START_BIT: begin
        if (count == 1 && in == 0) begin
          next_state = DATA_BITS;
          count = 0;
        end
        else begin
          next_state = START_BIT;
        end
      end

      DATA_BITS: begin
        if (count >=0 && count < 8) begin
          data[count] = in;
          next_state = DATA_BITS;
        end
        else if (count == 8) begin
          next_state = STOP_BIT;
        end
        else begin
          next_state = START_BIT;
        end
      end

      STOP_BIT: begin
        if (count == 1 && in == 1) begin
          next_state = IDLE;
        end
        else begin
          next_state = STOP_BIT;
        end
      end
    endcase
  end

endmodule