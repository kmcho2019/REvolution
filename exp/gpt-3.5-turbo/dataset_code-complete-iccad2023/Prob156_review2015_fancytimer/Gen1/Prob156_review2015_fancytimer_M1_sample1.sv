module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

typedef enum logic [3:0] { IDLE, SEARCH_START, SEARCH_PATTERN, DETECTED, COUNTING, WAIT_ACK } state_t;
reg [3:0] delay;
reg [4:0] pattern;
reg [2:0] pattern_index;

state_t state, next_state;

always_ff @ (posedge clk) begin
  if (reset) begin
    state <= IDLE;
    counting <= 0;
    done <= 0;
    delay <= 4'b0;
    pattern <= 5'b1101;
    pattern_index <= 3'b0;
  end
  else begin
    state <= next_state;
  end
end

always_comb begin
  next_state = state;
  count = (state == COUNTING) ? delay : 4'b0;

  case(state)
    IDLE: begin
      if (data == 1) begin
        next_state = SEARCH_START;
      end
    end

    SEARCH_START: begin
      if (data == 1) begin
        next_state = SEARCH_PATTERN;
      end else begin
        next_state = IDLE;
      end
    end

    SEARCH_PATTERN: begin
      if (pattern_index < 4) begin
        if (data == pattern[pattern_index +: 1]) begin
          pattern_index <= pattern_index + 1;
        end else begin
          next_state = IDLE;
        end
      end else begin
        pattern_index <= 0;
        next_state = DETECTED;
      end
    end

    DETECTED: begin
      delay <= {data, delay[3:1]};
      counting <= 1;
      next_state = COUNTING;
    end

    COUNTING: begin
      if (delay > 0) begin
        delay <= delay - 1;
      end else begin
        done <= 1;
        next_state = WAIT_ACK;
      end
    end

    WAIT_ACK: begin
      if (ack == 1) begin
        done <= 0;
        next_state = IDLE;
      end
    end
  endcase
end

endmodule