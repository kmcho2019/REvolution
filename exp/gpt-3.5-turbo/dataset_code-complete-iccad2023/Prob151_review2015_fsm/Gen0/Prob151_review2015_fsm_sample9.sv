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

localparam IDLE = 2'b00;
localparam DETECT_PATTERN = 2'b01;
localparam SHIFT_DELAY = 2'b10;
localparam WAIT_COUNTING_DONE = 2'b11;

reg [1:0] state, next_state;

always @ (posedge clk) begin
  if (reset) begin
    state <= IDLE;
    shift_ena <= 0;
    counting <= 0;
    done <= 0;
  end
  else begin
    state <= next_state;
  end
end

always @* begin
  case (state)
    IDLE: begin
      if (data == 4'b1101) begin
        next_state = DETECT_PATTERN;
      end
      else begin
        next_state = IDLE;
      end
    end
    DETECT_PATTERN: begin
      next_state = SHIFT_DELAY;
    end
    SHIFT_DELAY: begin
      next_state = WAIT_COUNTING_DONE;
    end
    WAIT_COUNTING_DONE: begin
      if (done_counting) begin
        done <= 1;
        next_state = done && ack ? IDLE : WAIT_COUNTING_DONE;
      end
    end
    default: next_state = IDLE;
  endcase
end

always @* begin
  shift_ena = (state == SHIFT_DELAY);
  counting = (state == WAIT_COUNTING_DONE);
end

endmodule