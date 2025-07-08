module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

  // State encoding
  localparam A = 2'b00;
  localparam B = 2'b01;
  localparam C = 2'b10;
  localparam D = 2'b11;

  reg [1:0] state, next_state;

  // State register with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= A;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (state)
      A: next_state = in ? B : A;
      B: next_state = in ? B : C;
      C: next_state = in ? D : A;
      D: next_state = in ? B : C;
      default: next_state = A;
    endcase
  end

  // Output logic (Moore machine: output depends only on state)
  always @(*) begin
    case (state)
      D: out = 1'b1;
      default: out = 1'b0;
    endcase
  end

endmodule