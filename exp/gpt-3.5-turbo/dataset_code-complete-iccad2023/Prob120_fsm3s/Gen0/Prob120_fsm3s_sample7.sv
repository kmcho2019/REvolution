module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

  // Define states
  parameter A = 2'b00;
  parameter B = 2'b01;
  parameter C = 2'b10;
  parameter D = 2'b11;

  // State register
  reg [1:0] state, next_state;

  // Moore outputs
  always @(*)
  begin
    case(state)
      A: out = 1'b0;
      B: out = 1'b0;
      C: out = 1'b0;
      D: out = 1'b1;
      default: out = 1'b0;
    endcase
  end

  // State transition logic
  always @(posedge clk or posedge reset)
  begin
    if (reset)
      state <= A;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*)
  begin
    case(state)
      A: next_state = (in ? B : A);
      B: next_state = (in ? B : C);
      C: next_state = (in ? D : A);
      D: next_state = (in ? B : C);
      default: next_state = A;
    endcase
  end

endmodule