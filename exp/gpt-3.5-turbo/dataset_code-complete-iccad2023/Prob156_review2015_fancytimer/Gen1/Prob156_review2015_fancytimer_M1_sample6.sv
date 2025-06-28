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
reg [3:0] delay_reg;
reg [4:0] shift_reg;
reg [3:0] remaining_time;

state_t state, next_state;

always_ff @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    counting <= 0;
    done <= 0;
    delay_reg <= 4'b0;
    shift_reg <= 5'b0;
    remaining_time <= 4'b0;
  end
  else begin
    state <= next_state;
  end
end

always_comb begin
  next_state = state;

  case(state)
    IDLE: begin
      if (data & !shift_reg[4]) begin
        shift_reg <= {shift_reg[3:0], data};
        if (shift_reg == 5'b11010) begin
          next_state = PATTERN;
          shift_reg <= 5'b0;
        end
      end
    end

    PATTERN: begin
      shift_reg <= {shift_reg[3:0], data};
      if (shift_reg[0]) begin
        delay_reg <= shift_reg[4:1];
        counting <= 1;
        remaining_time <= delay_reg;
        count <= remaining_time;
        next_state = COUNTING;
      end
    end

    COUNTING: begin
      if (remaining_time > 0) begin
        remaining_time <= remaining_time - 1;
        if (remaining_time == 0) begin
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