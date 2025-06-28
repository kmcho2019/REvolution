module MooreStateMachine (
  input clk,
  input in,
  input reset,
  output reg out,
  output reg [1:0] state
);

// State parameters
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
always @(posedge clk or posedge reset)
begin
  if (reset)
    state <= A;
  else
    case(state)
      A: state <= (in) ? B : A;
      B: state <= (in) ? B : C;
      C: state <= (in) ? D : A;
      D: state <= (in) ? B : C;
    endcase
end

// Output logic
always @(state)
begin
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
  input reset,
  output out
);

reg out;
wire [1:0] state;

MooreStateMachine fsm (
  .clk(clk),
  .in(in),
  .reset(reset),
  .out(out),
  .state(state)
);

assign out = fsm.out;

endmodule