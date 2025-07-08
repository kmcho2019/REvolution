module TopModule (
  input clk,
  input areset,
  input x,
  output z
);
  // One-hot encoding of states
  // State A = 2'b01
  // State B = 2'b10
  typedef enum logic [1:0] {
    A = 2'b01,
    B = 2'b10
  } state_t;
  
  state_t state, next_state;
  
  // Next state logic
  always_comb begin
    case(state)
      A: if (x == 1'b0) next_state = A;
         else next_state = B;
      B: next_state = B;
      default: next_state = A;
    endcase
  end
  
  // State register with asynchronous active-high reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset)
      state <= A;
    else
      state <= next_state;
  end
  
  // Output logic (Mealy): depends on state and input x
  // From diagram:
  // A,x=0 -> z=0
  // A,x=1 -> z=1
  // B,x=0 -> z=1
  // B,x=1 -> z=0
  assign z = (state == A) ? x : ~x;
  
endmodule