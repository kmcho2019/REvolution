module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

  // State encoding
  // 1'b1 = B, 1'b0 = A
  reg state, next_state;

  // Asynchronous reset and state update
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= 1'b1; // Reset to state B
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (state)
      1'b1: begin // B state
        if (in == 1'b0)
          next_state = 1'b0; // go to A
        else
          next_state = 1'b1; // stay in B
      end
      1'b0: begin // A state
        if (in == 1'b0)
          next_state = 1'b1; // go to B
        else
          next_state = 1'b0; // stay in A
      end
      default: next_state = 1'b1; // default to B for safety
    endcase
  end

  // Output logic (Moore)
  always @(*) begin
    case (state)
      1'b1: out = 1'b1; // B outputs 1
      1'b0: out = 1'b0; // A outputs 0
      default: out = 1'b1;
    endcase
  end

endmodule