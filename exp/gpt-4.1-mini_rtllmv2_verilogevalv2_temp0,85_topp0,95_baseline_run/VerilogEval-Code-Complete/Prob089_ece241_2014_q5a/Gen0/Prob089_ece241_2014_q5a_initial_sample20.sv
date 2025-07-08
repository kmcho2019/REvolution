module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // State encoding
  typedef enum logic [0:0] {
    S0 = 1'b0, // Before first '1' detected
    S1 = 1'b1  // After first '1' detected
  } state_t;

  state_t state, next_state;

  // State transition
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= S0;
      z <= 1'b0;
    end else begin
      state <= next_state;
      // Output depends on state and input (Moore)
      case (state)
        S0: z <= x;       // Copy input until first '1'
        S1: z <= ~x;      // Invert input bits after first '1'
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      S0: next_state = (x == 1'b1) ? S1 : S0;
      S1: next_state = S1;
      default: next_state = S0;
    endcase
  end

endmodule