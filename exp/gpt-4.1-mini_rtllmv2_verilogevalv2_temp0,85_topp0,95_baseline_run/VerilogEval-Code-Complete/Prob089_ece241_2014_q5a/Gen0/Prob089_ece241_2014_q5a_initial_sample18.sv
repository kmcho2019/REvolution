module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // State encoding
  typedef enum logic [0:0] {
    S0 = 1'b0, // copying input until first '1' found
    S1 = 1'b1  // inverting bits after first '1'
  } state_t;

  state_t state, next_state;

  // State register with asynchronous reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset)
      state <= S0;
    else
      state <= next_state;
  end

  // Next state logic
  always_comb begin
    case (state)
      S0: next_state = (x == 1'b1) ? S1 : S0;
      S1: next_state = S1;
      default: next_state = S0;
    endcase
  end

  // Output logic (Moore machine output depends on state)
  always_comb begin
    case (state)
      S0: z = x;
      S1: z = ~x;
      default: z = 1'b0;
    endcase
  end

endmodule