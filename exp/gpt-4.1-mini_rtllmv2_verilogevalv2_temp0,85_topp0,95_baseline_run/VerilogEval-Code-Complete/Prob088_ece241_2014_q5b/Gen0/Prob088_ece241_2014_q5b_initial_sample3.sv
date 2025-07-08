module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);
  // One-hot encoding for states
  localparam A = 2'b01;
  localparam B = 2'b10;

  reg [1:0] state, next_state;

  // State transition logic
  always @(*) begin
    case(state)
      A: if (x) next_state = B; else next_state = A;
      B: next_state = B;
      default: next_state = A;
    endcase
  end

  // Output logic (Mealy machine: depends on current state and input)
  always @(*) begin
    case(state)
      A: z = x ? 1'b1 : 1'b0;
      B: z = x ? 1'b0 : 1'b1;
      default: z = 1'b0;
    endcase
  end

  // State register with asynchronous active-high reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= A;
    else
      state <= next_state;
  end
endmodule