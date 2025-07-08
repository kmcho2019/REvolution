module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // One-hot state encoding
  parameter A = 2'b01;
  parameter B = 2'b10;

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
      A: begin
        if (x == 1'b0)
          next_state = A;
        else
          next_state = B;
      end
      B: begin
        next_state = B;
      end
      default: next_state = A;
    endcase
  end

  // Output logic (Mealy): z depends on current state and input x
  always @(*) begin
    case (state)
      A: z = (x == 1'b1) ? 1'b1 : 1'b0;
      B: z = (x == 1'b0) ? 1'b1 : 1'b0;
      default: z = 1'b0;
    endcase
  end

endmodule