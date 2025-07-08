module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

  // Define state encoding
  typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
  } state_t;

  state_t state, next_state;

  // Next state logic combinational
  always @(*) begin
    case (state)
      A: next_state = (in == 0) ? A : B;
      B: next_state = (in == 0) ? C : B;
      C: next_state = (in == 0) ? A : D;
      D: next_state = (in == 0) ? C : B;
      default: next_state = A;
    endcase
  end

  // State register with synchronous reset
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end

  // Output logic - Moore output depends only on state
  always @(*) begin
    case (state)
      D: out = 1;
      default: out = 0;
    endcase
  end

endmodule