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

  // State definitions
  parameter IDLE = 2'd0, PATTERN_DETECT = 2'd1, WAIT_COUNT = 2'd2, DONE = 2'd3;
  reg [1:0] state, next_state;

  // Additional signal for controlling counting operation independently
  reg count_ena;

  always @* begin
    case (state)
      IDLE: begin
        if (data == 4'b1101) begin
          next_state = WAIT_COUNT;
          shift_ena = 1;
          count_ena = 0;
        end else begin
          next_state = IDLE;
          shift_ena = 0;
          count_ena = 0;
        end
      end
      PATTERN_DETECT: begin
        next_state = IDLE;
        shift_ena = 0;
        count_ena = 0;
      end
      WAIT_COUNT: begin
        if (count_ena) begin
          next_state = DONE;
          shift_ena = 0;
          counting = 0;
        end else if (done_counting) begin
          next_state = PATTERN_DETECT;
          shift_ena = 0;
          count_ena = 0;
        end else begin
          next_state = WAIT_COUNT;
          shift_ena = 1;
          counting = 1;
        end
      end
      DONE: begin
        if (ack) begin
          next_state = IDLE;
          done = 0;
          count_ena = 0;
        end else begin
          next_state = DONE;
          done = 1;
          count_ena = 0;
        end
      end
    endcase
  end

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

endmodule