module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // One-hot encoded states
  localparam A = 2'b01,
             B = 2'b10;

  reg [1:0] state, next_state;

  // State register with asynchronous active-high reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= A;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case(state)
      A: begin
        if (x == 1'b0)
          next_state = A;
        else
          next_state = B;
      end
      B: begin
        next_state = B; // B loops to itself regardless of x
      end
      default: next_state = A;
    endcase
  end

  // Output logic (Mealy machine) depends on current state and input x
  always @(*) begin
    case(state)
      A: z = (x == 1'b0) ? 1'b0 : 1'b1;
      B: z = (x == 1'b0) ? 1'b1 : 1'b0;
      default: z = 1'b0;
    endcase
  end

endmodule