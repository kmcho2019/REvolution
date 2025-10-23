module TopModule(
  input clk,
  input resetn,
  input [2:0] r,
  output [2:0] g
);

// State codes
parameter A = 2'b00, B = 2'b01, C = 2'b10;

// Internal state signal
reg [1:0] state, next_state;

// Continuous assignments for outputs
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = 1'b0; // Since state D is not used

// Next state logic
always @(*) begin
  case (state)
    A: begin
      if (~r[0] && r[1])
        next_state = C;
      else if (r[0])
        next_state = B;
      else
        next_state = A;
    end
    B: begin
      if (~r[0])
        next_state = A;
      else
        next_state = B;
    end
    C: begin
      if (~r[1])
        next_state = A;
      else
        next_state = C;
    end
    default: next_state = A;
  endcase
end

// State flip-flops
always @(posedge clk) begin
  if (~resetn) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

endmodule