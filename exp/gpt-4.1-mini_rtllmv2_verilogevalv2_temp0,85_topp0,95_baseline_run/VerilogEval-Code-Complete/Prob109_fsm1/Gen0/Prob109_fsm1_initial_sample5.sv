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

  // Async reset and state register
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= B;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (state)
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
      default: next_state = B; // default to B if unknown
    endcase
  end

  // Output logic (Moore): output depends only on current state
  always @(*) begin
    case (state)
      A: out = 1'b0;
      B: out = 1'b1;
      default: out = 1'b1;
    endcase
  end

endmodule