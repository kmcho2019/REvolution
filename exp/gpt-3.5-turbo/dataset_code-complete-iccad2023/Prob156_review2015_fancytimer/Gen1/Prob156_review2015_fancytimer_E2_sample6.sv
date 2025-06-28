module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

typedef enum logic [1:0] { IDLE, SEARCH_START, READ_DELAY, COUNTING, TIMER_DONE } state_t;
reg [1:0] state, next_state;
reg [3:0] delay;
reg [3:0] remaining_count;
reg [11:0] counter;
reg [3:0] shift_reg;
reg [3:0] shift_cnt;

always_ff @ (posedge clk, posedge reset) begin
  if (reset) begin
    state <= IDLE;
    next_state <= IDLE;
    counting <= 0;
    done <= 0;
    delay <= 4'b0;
    remaining_count <= 4'b0;
    counter <= 12'b0;
    shift_reg <= 4'b0;
    shift_cnt <= 4'b0;
  end
  else begin
    state <= next_state;
  end
end

always @* begin
  next_state = state;
  count = counting ? remaining_count : 4'b0;

  case(state)
    IDLE: begin
      if (data == 1) begin
        next_state = SEARCH_START;
      end
    end

    SEARCH_START: begin
      if (data == 1 && shift_cnt < 3) begin
        shift_reg = {data, shift_reg[3:1]};
        shift_cnt = shift_cnt + 1;
      end
      else if (shift_cnt == 3 && shift_reg == 4'b1101) begin
        next_state = READ_DELAY;
        shift_cnt = 0;
      end
      else if (data != 1) begin
        shift_reg = 4'b0;
        shift_cnt = 0;
      end
    end

    READ_DELAY: begin
      if (shift_cnt < 4) begin
        shift_reg = {data, shift_reg[3:1]};
        shift_cnt = shift_cnt + 1;
      end
      if (shift_cnt == 4) begin
        delay = shift_reg;
        remaining_count = delay;
        next_state = COUNTING;
      end
    end

    COUNTING: begin
      if (counter < (remaining_count + 1) * 1000 - 1) begin
        counter = counter + 1;
        if (counter % 1000 == 0 && remaining_count > 0) begin
          remaining_count = remaining_count - 1;
        end
      end
      else begin
        next_state = TIMER_DONE;
      end
    end

    TIMER_DONE: begin
      done = 1;
      counting = 0;
      if (ack) begin
        done = 0;
        next_state = IDLE;
      end
    end
  endcase
end

endmodule