module MooreStateMachine (
  input clk,
  input in,
  input reset,
  output reg out,
  output reg [1:0] state
);

// State encoding: A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

always @(posedge clk) begin
  if (reset) begin
    state <= A;
  end else begin
    case(state)
      A: begin
        if (in)
          state <= B;
        else
          state <= A;
      end
      B: begin
        if (in)
          state <= B;
        else
          state <= C;
      end
      C: begin
        if (in)
          state <= D;
        else
          state <= A;
      end
      D: begin
        if (in)
          state <= B;
        else
          state <= C;
      end
    endcase
  end
end

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
  input reset,
  output out
);

MooreStateMachine fsm (
  .clk(clk),
  .in(in),
  .reset(reset),
  .out(out)
);

endmodule