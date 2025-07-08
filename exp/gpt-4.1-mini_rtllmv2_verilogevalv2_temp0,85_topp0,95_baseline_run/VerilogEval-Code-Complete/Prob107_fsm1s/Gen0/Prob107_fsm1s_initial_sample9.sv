module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

  // State encoding
  typedef enum logic [0:0] {
    B = 1'b0,
    A = 1'b1
  } state_t;

  state_t state, next_state;

  // Next state logic
  always @(*) begin
    case(state)
      B: begin
        if (in == 1'b0)
          next_state = A;
        else
          next_state = B;
      end
      A: begin
        if (in == 1'b0)
          next_state = B;
        else
          next_state = A;
      end
      default: next_state = B;
    endcase
  end

  // State register with synchronous active-high reset
  always @(posedge clk) begin
    if (reset)
      state <= B;
    else
      state <= next_state;
  end

  // Output logic (Moore)
  always @(*) begin
    case(state)
      B: out = 1'b1;
      A: out = 1'b0;
      default: out = 1'b1;
    endcase
  end

endmodule