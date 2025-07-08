module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

  // State encoding
  localparam IDLE = 2'd0,
             BYTE2 = 2'd1,
             BYTE3 = 2'd2;

  reg [1:0] state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 1'b0;
    end else begin
      state <= next_state;
      // done is asserted only when leaving BYTE3 state (i.e., message complete)
      if (state == BYTE3)
        done <= 1'b1;
      else
        done <= 1'b0;
    end
  end

  always @(*) begin
    case(state)
      IDLE: begin
        if (in[3])
          next_state = BYTE2;
        else
          next_state = IDLE;
      end
      BYTE2: begin
        if (in[3])
          next_state = BYTE2;  // new message start detected, resync
        else
          next_state = BYTE3;
      end
      BYTE3: begin
        if (in[3])
          next_state = BYTE2;  // new message start detected
        else
          next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

endmodule