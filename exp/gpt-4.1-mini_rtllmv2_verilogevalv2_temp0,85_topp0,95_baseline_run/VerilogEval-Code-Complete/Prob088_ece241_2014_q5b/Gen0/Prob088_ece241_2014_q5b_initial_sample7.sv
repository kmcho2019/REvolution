module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // One-hot state encoding: stateA=2'b01, stateB=2'b10
  reg [1:0] state, next_state;

  // Asynchronous active-high reset and synchronous state update
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= 2'b01; // state A
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (state)
      2'b01: // state A
        if (x == 1'b0)
          next_state = 2'b01; // stay in A
        else
          next_state = 2'b10; // go to B
      2'b10: // state B
        next_state = 2'b10; // stay in B regardless of x
      default:
        next_state = 2'b01; // default to A for safety
    endcase
  end

  // Output logic (Mealy output)
  always @(*) begin
    case (state)
      2'b01: z = (x == 1'b1) ? 1'b1 : 1'b0; // z=1 if x=1, else 0
      2'b10: z = (x == 1'b0) ? 1'b1 : 1'b0; // z=1 if x=0, else 0
      default: z = 1'b0;
    endcase
  end

endmodule