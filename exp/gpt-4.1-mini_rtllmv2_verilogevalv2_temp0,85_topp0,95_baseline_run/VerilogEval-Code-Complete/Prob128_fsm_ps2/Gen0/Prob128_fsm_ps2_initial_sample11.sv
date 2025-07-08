module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

  // FSM states
  localparam WAIT_FOR_START = 2'd0,
             BYTE1          = 2'd1,
             BYTE2          = 2'd2;

  reg [1:0] state, next_state;

  // State transition
  always @(posedge clk) begin
    if (reset)
      state <= WAIT_FOR_START;
    else
      state <= next_state;
  end

  // Next state logic and done signal
  always @(*) begin
    done = 1'b0;
    case(state)
      WAIT_FOR_START: begin
        if (in[3] == 1'b1)
          next_state = BYTE1;
        else
          next_state = WAIT_FOR_START;
      end
      BYTE1: begin
        next_state = BYTE2;
      end
      BYTE2: begin
        // After third byte, signal done and go back to waiting
        next_state = WAIT_FOR_START;
      end
      default: begin
        next_state = WAIT_FOR_START;
      end
    endcase
  end

  // done is asserted one cycle after receiving third byte (when in BYTE2 state, next cycle is WAIT_FOR_START)
  // So we assert done when transitioning from BYTE2 to WAIT_FOR_START, i.e. on BYTE2 state
  // We do this by asserting done in the cycle the FSM is in BYTE2 state
  always @(posedge clk) begin
    if (reset)
      done <= 1'b0;
    else
      done <= (state == BYTE2);
  end

endmodule