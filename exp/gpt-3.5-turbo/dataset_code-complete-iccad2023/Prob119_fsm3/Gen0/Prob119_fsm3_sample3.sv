module MooreStateMachine (
  input clk,
  input in,
  input areset,
  output reg out,
  output reg [1:0] state
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= A;
  end else begin
    case(state)
      A: state <= (in) ? B : A;
      B: state <= (in) ? B : C;
      C: state <= (in) ? D : A;
      D: state <= (in) ? B : C;
    endcase
  end
end

// Output logic
always @* begin
  case(state)
    A: out = 1'b0;
    B: out = 1'b0;
    C: out = 1'b0;
    D: out = 1'b1;
  endcase
end

endmodule

module TopModule (
  input clk,
  input in,
  input areset,
  output out
);

reg [1:0] state;

MooreStateMachine fsm (
  .clk(clk),
  .in(in),
  .areset(areset),
  .out(out),
  .state(state)
);

endmodule