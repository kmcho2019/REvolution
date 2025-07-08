module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

  // State encoding
  localparam IDLE  = 2'd0;
  localparam BYTE2 = 2'd1;
  localparam BYTE3 = 2'd2;

  reg [1:0] state, next_state;

  // State transition logic
  always @(posedge clk) begin
    if (reset)
      state <= IDLE;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case(state)
      IDLE: begin
        if (in[3])
          next_state = BYTE2;
        else
          next_state = IDLE;
      end
      BYTE2: begin
        next_state = BYTE3;
      end
      BYTE3: begin
        next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

  // done signal logic
  always @(posedge clk) begin
    if (reset)
      done <= 1'b0;
    else
      done <= (state == BYTE3);
  end

endmodule