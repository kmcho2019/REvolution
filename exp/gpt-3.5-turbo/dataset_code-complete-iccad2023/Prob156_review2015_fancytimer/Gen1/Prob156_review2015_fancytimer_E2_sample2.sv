module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  typedef enum logic [3:0] {IDLE, DETECT_PATTERN, READ_DELAY, COUNTING, WAIT_FOR_ACK} state_t;
  reg [3:0] delay;
  reg [3:0] delay_counter;
  reg [3:0] remaining_time;
  reg [3:0] shift_reg;
  reg [3:0] shift_cnt;
  state_t state, next_state;

  always_ff @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      counting <= 0;
      done <= 0;
      delay <= 0;
      delay_counter <= 0;
      remaining_time <= 0;
      count <= 0;
      shift_reg <= 0;
      shift_cnt <= 0;
    end else begin
      state <= next_state;
    end
  end

  always_comb begin
    next_state = state;
    counting = 0;
    count = (state == COUNTING) ? remaining_time : 4'bxxxx;

    case(state)
      IDLE: begin
        if (data == 1'b1 && shift_reg == 4'b1101) begin
          next_state = READ_DELAY;
          shift_cnt <= 0;
        end else begin
          shift_reg <= {data, shift_reg[3:1]};
        end
      end
      READ_DELAY: begin
        if (shift_cnt < 4) begin
          delay <= {data, delay[3:1]};
          shift_cnt <= shift_cnt + 1;
        end else begin
          remaining_time <= delay;
          delay_counter <= delay + 1;
          counting <= 1;
          next_state = COUNTING;
        end
      end
      COUNTING: begin
        if (delay_counter > 0) begin
          delay_counter <= delay_counter - 1;
        end else begin
          counting <= 0;
          done <= 1;
          next_state = WAIT_FOR_ACK;
        end
      end
      WAIT_FOR_ACK: begin
        if (ack == 1) begin
          done <= 0;
          next_state = IDLE;
        end
      end
    endcase
  end

endmodule