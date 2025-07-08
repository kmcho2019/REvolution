module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

  // State encoding
  localparam A = 2'd0;
  localparam B = 2'd1;
  localparam C = 2'd2;
  localparam D = 2'd3;

  reg [1:0] current_state, next_state;

  // State register with synchronous active high reset
  always @(posedge clk) begin
    if (reset)
      current_state <= A;
    else
      current_state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (current_state)
      A: next_state = (in == 0) ? A : B;
      B: next_state = (in == 0) ? C : B;
      C: next_state = (in == 0) ? A : D;
      D: next_state = (in == 0) ? C : B;
      default: next_state = A;
    endcase
  end

  // Output logic (Moore machine output depends only on current_state)
  always @(*) begin
    case (current_state)
      D: out = 1'b1;
      default: out = 1'b0;
    endcase
  end

endmodule