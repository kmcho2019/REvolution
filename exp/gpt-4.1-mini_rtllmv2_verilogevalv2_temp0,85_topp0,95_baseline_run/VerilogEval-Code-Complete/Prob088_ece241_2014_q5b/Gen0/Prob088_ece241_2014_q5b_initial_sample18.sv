module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // One-hot encoding of states
  localparam A = 2'b01;
  localparam B = 2'b10;

  reg [1:0] state, next_state;

  // Asynchronous reset and state register
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= A;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (state)
      A: next_state = (x) ? B : A;
      B: next_state = B;
      default: next_state = A;
    endcase
  end

  // Output logic (Mealy)
  always @(*) begin
    case (state)
      A: z = (x) ? 1'b1 : 1'b0;
      B: z = (x) ? 1'b0 : 1'b1;
      default: z = 1'b0;
    endcase
  end

endmodule