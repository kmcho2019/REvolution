module TopModule (
  input clk,
  input reset,
  input data,
  output reg shift_ena,
  output reg counting,
  input done_counting,
  output reg done,
  input ack
);

  typedef enum logic [2:0] {
    IDLE,
    SEARCH_PATTERN,
    SHIFT_IN,
    WAIT_COUNTING,
    DONE
  } state_t;

  reg [1:0] pattern_detection;
  reg [3:0] shift_count;
  state_t state, next_state;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      pattern_detection <= 2'b0;
      shift_count <= 4'b0;
      shift_ena <= 1'b0;
      counting <= 1'b0;
      done <= 1'b0;
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    shift_ena = 1'b0;
    counting = 1'b0;
    next_state = state;
  
    case(state)
      IDLE:
        if (data == 1'b1 && pattern_detection == 2'b01) begin
          next_state = SEARCH_PATTERN;
        end else begin
          pattern_detection <= {pattern_detection[0], data};
        end
      SEARCH_PATTERN:
        if (data == 1'b0) begin
          pattern_detection <= {pattern_detection[0], data};
          next_state = IDLE;
        end else if (pattern_detection == 2'b1101) begin
          next_state = SHIFT_IN;
        end else begin
          pattern_detection <= {pattern_detection[0], data};
        end
      SHIFT_IN:
        shift_ena = 1'b1;
        shift_count = shift_count + 1;
        if (shift_count == 4) begin
          next_state = WAIT_COUNTING;
        end
      WAIT_COUNTING:
        counting = 1'b1;
        if (done_counting) begin
          next_state = DONE;
        end
      DONE:
        done = 1'b1;
        if (ack) begin
          next_state = IDLE;
        end
    endcase
  end

endmodule