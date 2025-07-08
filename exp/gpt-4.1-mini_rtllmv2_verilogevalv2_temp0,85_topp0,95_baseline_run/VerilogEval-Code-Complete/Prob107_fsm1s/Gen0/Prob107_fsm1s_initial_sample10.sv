module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

  // State encoding
  localparam A = 1'b0;
  localparam B = 1'b1;

  reg state, next_state;

  // State transition
  always @(posedge clk) begin
    if (reset)
      state <= B;  // reset state is B
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

  // Output logic (Moore, depends on state only)
  always @(*) begin
    case(state)
      B: out = 1'b1;
      A: out = 1'b0;
      default: out = 1'b1;
    endcase
  end

endmodule