module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

  typedef enum logic {
    B = 1'b0,
    A = 1'b1
  } state_t;

  state_t state, next_state;

  // State register with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= B;
    else
      state <= next_state;
  end

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

  // Output logic (Moore machine output depends on state only)
  always @(*) begin
    case(state)
      B: out = 1'b1;
      A: out = 1'b0;
      default: out = 1'b1;
    endcase
  end

endmodule