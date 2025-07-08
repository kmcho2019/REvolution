module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

  // Define states encoding
  localparam A = 2'd0,
             B = 2'd1,
             C = 2'd2,
             D = 2'd3;

  reg [1:0] state, next_state;

  // State transition logic (combinational)
  always @(*) begin
    case (state)
      A: next_state = in ? B : A;
      B: next_state = in ? B : C;
      C: next_state = in ? D : A;
      D: next_state = in ? B : C;
      default: next_state = A;
    endcase
  end

  // State flip-flops with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= A;
    else
      state <= next_state;
  end

  // Output logic (Moore)
  always @(*) begin
    case (state)
      D: out = 1'b1;
      default: out = 1'b0;
    endcase
  end

endmodule