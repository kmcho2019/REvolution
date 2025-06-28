module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

  // State encoding
  parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;

  // State register
  reg [2:0] state, next_state;

  // Next state logic
  always @(*) begin
    case(state)
      A: next_state = (w) ? D : B;
      B: next_state = (w) ? D : C;
      C: next_state = (w) ? D : E;
      D: next_state = (w) ? A : F;
      E: next_state = (w) ? D : E;
      F: next_state = (w) ? D : C;
    endcase
  end

  // State transition
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end

  // Output z logic
  assign z = (state == E) ? 1'b1 : 1'b0;

endmodule