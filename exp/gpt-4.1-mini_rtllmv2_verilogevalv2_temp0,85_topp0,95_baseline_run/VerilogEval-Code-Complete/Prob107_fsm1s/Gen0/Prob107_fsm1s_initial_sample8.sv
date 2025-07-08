module TopModule (
  input clk,
  input in,
  input reset,
  output out
);

  // State encoding
  typedef enum logic {B=1'b0, A=1'b1} state_t;
  state_t state, next_state;

  // State transition logic
  always_ff @(posedge clk) begin
    if (reset) 
      state <= B;
    else 
      state <= next_state;
  end

  // Next state combinational logic
  always_comb begin
    case (state)
      B: next_state = (in == 1'b0) ? A : B;
      A: next_state = (in == 1'b0) ? B : A;
      default: next_state = B;
    endcase
  end

  // Moore output depends on current state
  assign out = (state == B) ? 1'b1 : 1'b0;

endmodule