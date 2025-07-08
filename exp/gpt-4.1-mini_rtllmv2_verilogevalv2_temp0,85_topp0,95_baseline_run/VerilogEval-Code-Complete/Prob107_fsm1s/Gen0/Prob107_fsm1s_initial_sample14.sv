module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

  // State encoding
  typedef enum logic {
    B = 1'b0,
    A = 1'b1
  } state_t;

  state_t current_state, next_state;

  // State register with synchronous reset
  always @(posedge clk) begin
    if (reset)
      current_state <= B;
    else
      current_state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (current_state)
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
      default: next_state = B; // default to B for safety
    endcase
  end

  // Output logic (Moore machine)
  always @(*) begin
    case (current_state)
      B: out = 1'b1;
      A: out = 1'b0;
      default: out = 1'b1; // default output for safety
    endcase
  end

endmodule