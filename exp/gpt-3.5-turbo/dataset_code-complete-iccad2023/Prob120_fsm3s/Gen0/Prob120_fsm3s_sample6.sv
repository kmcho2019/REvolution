module MooreFSM (
  input clk,
  input in,
  input reset,
  output reg out,
  output reg [1:0] state
);

// Define the states
parameter A=2'b00, B=2'b01, C=2'b10, D=2'b11;

// State register
always @(posedge clk) begin
  if (reset) begin
    state <= A; // Reset to state A
    out <= 0;   // Reset output
  end
  else begin
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
        out <= 1; // Output is 1 in state D
      end
    endcase
    out <= (state == D) ? 1 : 0; // Output logic for states A, B, C
  end
end

endmodule

module TopModule (
  input clk,
  input in,
  input reset,
  output out
);

MooreFSM my_fsm (
  .clk(clk),
  .in(in),
  .reset(reset),
  .out(out)
);

endmodule