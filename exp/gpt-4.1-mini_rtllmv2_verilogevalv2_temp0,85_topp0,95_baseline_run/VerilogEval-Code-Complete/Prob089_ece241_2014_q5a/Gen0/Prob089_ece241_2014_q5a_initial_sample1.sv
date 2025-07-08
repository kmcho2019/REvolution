module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // State encoding
  typedef enum reg [0:0] {
    S0 = 1'b0, // Copy input bits until first '1'
    S1 = 1'b1  // Invert input bits after first '1'
  } state_t;

  state_t state, next_state;

  // State register with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= S0;
    end else begin
      state <= next_state;
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

  // Output logic (Moore machine: output depends on state and input)
  always @(*) begin
    case (state)
      S0: z = x;       // copy bits until first 1
      S1: z = ~x;      // invert bits after first 1
      default: z = 1'b0;
    endcase
  end

endmodule