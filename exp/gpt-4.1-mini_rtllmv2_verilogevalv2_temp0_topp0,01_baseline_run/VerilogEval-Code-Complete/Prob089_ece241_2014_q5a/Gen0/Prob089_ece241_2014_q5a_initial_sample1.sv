module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // State encoding
  typedef enum logic [0:0] {
    S0 = 1'b0, // Before first '1' seen
    S1 = 1'b1  // After first '1' seen
  } state_t;

  state_t state, next_state;

  // Next state logic
  always @(*) begin
    case (state)
      S0: next_state = (x == 1'b1) ? S1 : S0;
      S1: next_state = S1;
      default: next_state = S0;
    endcase
  end

  // State register with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= S0;
    else
      state <= next_state;
  end

  // Output logic (Moore machine: output depends only on state)
  always @(*) begin
    case (state)
      S0: z = x;      // Copy input until first '1'
      S1: z = ~x;     // Invert input after first '1'
      default: z = 1'b0;
    endcase
  end

endmodule