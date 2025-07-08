module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // State encoding
  typedef enum reg [0:0] {
    S0 = 1'b0, // Copy input bits until first '1'
    S1 = 1'b1  // Complement remaining bits
  } state_t;

  state_t state, next_state;

  // State transition
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= S0;
      z <= 1'b0;
    end else begin
      state <= next_state;
      // Output depends on state and input:
      // S0: output = input
      // S1: output = ~input
      if (state == S0)
        z <= x;
      else // S1
        z <= ~x;
    end
  end

  // Next state logic
  always @(*) begin
    case(state)
      S0: next_state = x ? S1 : S0;
      S1: next_state = S1;
      default: next_state = S0;
    endcase
  end

endmodule