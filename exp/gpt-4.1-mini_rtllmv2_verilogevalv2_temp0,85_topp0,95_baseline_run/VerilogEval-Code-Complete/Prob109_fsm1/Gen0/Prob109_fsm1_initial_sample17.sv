module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

  // State encoding
  localparam A = 1'b0;
  localparam B = 1'b1;

  reg state, next_state;

  // Asynchronous reset and state update
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= B;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case(state)
      B: // state B, output 1
        case(in)
          1'b0: next_state = A;
          1'b1: next_state = B;
        endcase
      A: // state A, output 0
        case(in)
          1'b0: next_state = B;
          1'b1: next_state = A;
        endcase
      default: next_state = B; // default to B
    endcase
  end

  // Output logic based on Moore machine (output depends only on state)
  always @(*) begin
    case(state)
      A: out = 1'b0;
      B: out = 1'b1;
      default: out = 1'b1;
    endcase
  end

endmodule