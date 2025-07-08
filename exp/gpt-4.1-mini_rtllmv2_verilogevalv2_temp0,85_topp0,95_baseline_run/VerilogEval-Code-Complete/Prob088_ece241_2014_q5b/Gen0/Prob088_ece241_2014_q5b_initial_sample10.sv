module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // One-hot state encoding
  // A = 2'b01, B = 2'b10
  reg [1:0] state, next_state;

  // State encoding parameters
  localparam A = 2'b01;
  localparam B = 2'b10;

  // Asynchronous active-high reset, state register
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
        // B state is stable on both inputs
        next_state = B;
      end
      default: next_state = A; // safe default
    endcase
  end

  // Output logic (Mealy output)
  always @(*) begin
    case (state)
      A: z = (x == 1'b1) ? 1'b1 : 1'b0;
      B: z = (x == 1'b0) ? 1'b1 : 1'b0;
      default: z = 1'b0;
    endcase
  end

endmodule