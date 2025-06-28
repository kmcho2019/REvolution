module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

typedef enum logic [3:0] { IDLE, DETECT_PATTERN, READ_DELAY, COUNTING, TIMER_DONE, WAIT_ACK } state_t;
reg [3:0] delay;
reg [3:0] count_reg;
reg [3:0] remaining_time;
reg [3:0] shift_reg;
reg [1:0] shift_cnt;
reg [1:0] start_pattern;
reg [1:0] pattern;
state_t state, next_state;

always_ff @ (posedge clk) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
    counting <= 0;
    count <= 4'bxxxx;
    delay <= 4'b0;
    count_reg <= 4'b0;
    remaining_time <= 4'b0;
    shift_reg <= 4'b0;
    shift_cnt <= 2'b00;
    start_pattern <= 2'b11;
  end
  else begin
    state <= next_state;
  end
end

always_comb begin
  next_state = state;
  count = (state == COUNTING) ? remaining_time : 4'bxxxx;

  case(state)
    IDLE: begin
      if (data == 1 && start_pattern == 2'b11) begin
        start_pattern <= {shift_reg[3], data};
        next_state = DETECT_PATTERN;
      end
    end

    DETECT_PATTERN: begin
      shift_reg <= {data, shift_reg[3:1]};
      if (start_pattern == 2'b1101) begin
        next_state = READ_DELAY;
      end
      else if (start_pattern == 2'b11) begin
        start_pattern <= {shift_reg[3], data};
      end
      else begin
        start_pattern <= 2'b11;
      end
    end

    READ_DELAY: begin
      if (shift_cnt < 4) begin
        shift_cnt <= shift_cnt + 1;
        shift_reg <= {data, shift_reg[3:1]};
      end
      if (shift_cnt == 4) begin
        delay <= shift_reg;
        count_reg <= delay + 1;
        remaining_time <= delay;
        counting <= 1;
        next_state = COUNTING;
      end
    end

    COUNTING: begin
      if (count_reg > 0) begin
        remaining_time <= remaining_time - 1;
        count_reg <= count_reg - 1;
        if (count_reg == 0) begin
          counting <= 0;
          done <= 1;
          next_state = WAIT_ACK;
        end
      end
    end

    WAIT_ACK: begin
      if (ack) begin
        done <= 0;
        start_pattern <= 2'b11;
        next_state = IDLE;
      end
    end
  endcase
end

endmodule