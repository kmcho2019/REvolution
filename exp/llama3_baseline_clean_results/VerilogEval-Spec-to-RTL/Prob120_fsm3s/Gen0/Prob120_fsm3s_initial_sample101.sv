module TopModule (
  input  clk,
  input  reset,
  input  in,
  output out
);

  // Define the states as an enum
  enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
  } state, next_state;

  // Assign the output based on the current state
  always_comb begin
    case (state)
      A, B, C: out = 1'b0;
      D: out = 1'b1;
      default: out = 1'bx;
    endcase
  end

  // Determine the next state based on the current state and the input
  always_comb begin
    case (state)
      A: next_state = in? B : A;
      B: next_state = in? B : C;
      C: next_state = in? D : A;
      D: next_state = in? B : C;
      default: next_state = 2'bx;
    endcase
  end

  // Update the state on the positive edge of the clock
  always_ff @(posedge clk) begin
    if (reset) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end

endmodule