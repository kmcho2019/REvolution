module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

  // State encoding
  localparam A = 2'b00;
  localparam B = 2'b01;
  localparam C = 2'b10;
  localparam D = 2'b11;

  reg [1:0] state, next_state;

  // Next state logic
  always @(*) begin
    case (state)
      A: next_state = (in == 0) ? A : B;
      B: next_state = (in == 0) ? C : B;
      C: next_state = (in == 0) ? A : D;
      D: next_state = (in == 0) ? C : B;
      default: next_state = A;
    endcase
  end

  // State update with synchronous reset
  always @(posedge clk) begin
    if (reset)
      state <= A;
    else
      state <= next_state;
  end

  // Output logic (Moore output depends only on state)
  always @(*) begin
    case (state)
      D: out = 1'b1;
      default: out = 1'b0;
    endcase
  end

endmodule