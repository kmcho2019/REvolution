module TopModule (
  input clk,
  input in,
  input areset,
  output out
);

  // State encoding
  localparam A = 1'b0;
  localparam B = 1'b1;

  reg state, next_state;

  // Asynchronous reset and state register
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= B; // reset to state B
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
      default: next_state = B; // default safe state
    endcase
  end

  // Output is state (Moore machine)
  assign out = state;

endmodule