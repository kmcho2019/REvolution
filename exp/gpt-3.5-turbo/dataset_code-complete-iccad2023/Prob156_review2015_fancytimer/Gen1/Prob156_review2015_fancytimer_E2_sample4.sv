module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

typedef enum logic [3:0] { IDLE, SEARCH, PATTERN, COUNTING, WAIT_ACK } state_t;
reg [3:0] delay;
reg [3:0] shift_reg;
integer count_remaining;

state_t state, next_state;

always_ff @ (posedge clk) begin
  if (reset) begin
    state <= IDLE;
    counting <= 0;
    done <= 0;
    shift_reg <= 4'b0;
    delay <= 4'b0;
    count <= 4'b0;
    count_remaining <= 0;
  end
  else begin
    state <= next_state;
  end
end

always_comb begin
  next_state = state;
  count = (state == COUNTING) ? count_remaining : 4'b0;

  case(state)
    IDLE: begin
      if (data && shift_reg[3:0] == 4'b1101) begin
        next_state = PATTERN;
        shift_reg <= 4'b0;
      end
    end

    SEARCH: begin
      if (data && shift_reg[3:0] == 4'b1101) begin
        next_state = PATTERN;
        shift_reg <= 4'b0;
      end
    end

    PATTERN: begin
      if (shift_reg < 4'b1111) begin
        shift_reg <= {data, shift_reg[3:1]};
      end
      else begin
        delay <= shift_reg[3:0];
        next_state = COUNTING;
        count_remaining <= (delay + 1) * 1000;
      end
    end

    COUNTING: begin
      if (count_remaining > 0) begin
        count_remaining <= count_remaining - 1;
        if (count_remaining == 0) begin
          done <= 1;
          next_state = WAIT_ACK;
        end
      end
    end

    WAIT_ACK: begin
      if (ack) begin
        done <= 0;
        next_state = IDLE;
      end
    end
  endcase
end

endmodule