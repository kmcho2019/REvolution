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
      state <= B; // reset to state B
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case(state)
      B: begin
        if (in == 1'b0)
          next_state = A;
        else
          next_state = B;
      end
      A: begin
        if (in == 1'b0)
          next_state = B;
        else
          next_state = A;
      end
      default: next_state = B; // default to B for safety
    endcase
  end

  // Output logic (Moore): output depends only on state
  always @(*) begin
    case(state)
      B: out = 1'b1;
      A: out = 1'b0;
      default: out = 1'b0;
    endcase
  end

endmodule