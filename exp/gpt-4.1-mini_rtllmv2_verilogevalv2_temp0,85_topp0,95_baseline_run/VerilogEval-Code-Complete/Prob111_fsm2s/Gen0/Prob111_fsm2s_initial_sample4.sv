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

  state_t current_state, next_state;

  // State transition
  always @(posedge clk) begin
    if (reset)
      current_state <= OFF;
    else
      current_state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (current_state)
      OFF: next_state = (j) ? ON : OFF;
      ON:  next_state = (k) ? OFF : ON;
      default: next_state = OFF;
    endcase
  end

  // Output logic (Moore output depends only on current state)
  always @(*) begin
    case (current_state)
      OFF: out = 1'b0;
      ON:  out = 1'b1;
      default: out = 1'b0;
    endcase
  end

endmodule