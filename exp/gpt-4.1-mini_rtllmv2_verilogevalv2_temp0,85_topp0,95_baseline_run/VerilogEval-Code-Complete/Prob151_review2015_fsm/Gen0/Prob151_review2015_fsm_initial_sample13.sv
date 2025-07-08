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

  // State encoding
  typedef enum logic [2:0] {
    IDLE        = 3'b000, // waiting for first '1'
    S1          = 3'b001, // matched '1'
    S11         = 3'b010, // matched '11'
    S110        = 3'b011, // matched '110'
    SHIFT_4     = 3'b100, // shift_ena asserted for 4 cycles
    COUNTING    = 3'b101, // counting asserted, wait done_counting
    DONE        = 3'b110  // done asserted, wait ack
  } state_t;

  state_t state, next_state;

  reg [2:0] shift_cnt; // count 4 shift cycles (0 to 3)

  // Next state logic and outputs combinational
  always @* begin
    // default outputs
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    next_state = state;

    case(state)
      IDLE: begin
        // Looking for pattern start: first bit '1'
        if (data == 1'b1)
          next_state = S1;
        else
          next_state = IDLE;
      end
      S1: begin
        if (data == 1'b1)
          next_state = S11;
        else // data == 0
          next_state = IDLE;
      end
      S11: begin
        if (data == 1'b0)
          next_state = S110;
        else // data == 1, restart matching from S11? Actually pattern is 1101, so if next bit is 1 after 11, pattern breaks
          next_state = S11; // if data=1, still matched "11" so stay S11
      end
      S110: begin
        if (data == 1'b1)
          next_state = SHIFT_4; // pattern detected 1101
        else if (data == 1'b0)
          next_state = IDLE;
      end
      SHIFT_4: begin
        shift_ena = 1'b1;
        if (shift_cnt == 3'd3)
          next_state = COUNTING;
        else
          next_state = SHIFT_4;
      end
      COUNTING: begin
        counting = 1'b1;
        if (done_counting)
          next_state = DONE;
        else
          next_state = COUNTING;
      end
      DONE: begin
        done = 1'b1;
        if (ack)
          next_state = IDLE;
        else
          next_state = DONE;
      end
      default: next_state = IDLE;
    endcase
  end

  // State register and shift counter
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      shift_cnt <= 3'd0;
    end else begin
      state <= next_state;
      if (state == SHIFT_4) begin
        if (shift_cnt == 3'd3)
          shift_cnt <= 3'd0;
        else
          shift_cnt <= shift_cnt + 3'd1;
      end else begin
        shift_cnt <= 3'd0;
      end
    end
  end

endmodule