module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output wire [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

typedef enum logic [3:0] { IDLE, SEARCH, PATTERN, COUNTING, WAIT_ACK } state_t;
reg [3:0] count_reg;
reg [3:0] delay;
reg [3:0] shift_reg;
reg [3:0] shift_cnt;
reg [3:0] remaining_time;
reg previous_data;
reg start_search;

state_t state, next_state;

always_ff @ (posedge clk) begin
  if (reset) begin
    state <= IDLE;
    counting <= 0;
    done <= 0;
    shift_reg <= 4'b0;
    shift_cnt <= 4'b0;
    count_reg <= 4'b0;
    delay <= 4'b0;
    remaining_time <= 4'b0;
    previous_data <= 1'b0;
    start_search <= 0;
  end
  else begin
    state <= next_state;
  end
end

always_comb begin
  next_state = state;
  counting = 0;
  count = (state == COUNTING) ? remaining_time : 4'b0;

  case(state)
    IDLE: begin
      if (data == 1 && previous_data == 1 && start_search == 0) begin
        start_search <= 1;
        next_state = SEARCH;
      end
      else begin
        start_search <= 0;
      end
    end

    SEARCH: begin
      if (data == 1 && previous_data == 1 && start_search == 1) begin
        next_state = PATTERN;
        shift_reg <= 4'b0;
        shift_cnt <= 4'b0;
      end
      else begin
        start_search <= 0;
      end
    end

    PATTERN: begin
      if (shift_cnt < 4) begin
        shift_reg <= {data, shift_reg[3:1]};
        shift_cnt <= shift_cnt + 1;
      end
      if (shift_cnt == 4) begin
        delay <= shift_reg;
        counting <= 1;
        count_reg <= delay + 1;
        remaining_time <= delay;
        next_state = COUNTING;
      end
    end

    COUNTING: begin
      if (count_reg > 0) begin
        count_reg <= count_reg - 1;
        if (count_reg == 0) begin
          done <= 1;
          next_state = WAIT_ACK;
        end
      end
    end

    WAIT_ACK: begin
      if (ack == 1) begin
        done <= 0;
        next_state = IDLE;
      end
    end
  endcase

  previous_data = data;
end

endmodule