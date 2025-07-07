module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

  // State encoding
  typedef enum logic [0:0] {
    OFF = 1'b0,
    ON  = 1'b1
  } state_t;

  state_t state, next_state;

  // Next state logic
  always @(*) begin
    case (state)
      OFF: next_state = (j == 1'b1) ? ON : OFF;
      ON:  next_state = (k == 1'b1) ? OFF : ON;
      default: next_state = OFF;
    endcase
  end

  // State register with synchronous reset
  always @(posedge clk) begin
    if (reset)
      state <= OFF;
    else
      state <= next_state;
  end

  // Output logic (Moore machine)
  always @(*) begin
    case (state)
      OFF: out = 1'b0;
      ON:  out = 1'b1;
      default: out = 1'b0;
    endcase
  end

endmodule