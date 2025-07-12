module TopModule(
  input clk,
  input resetn,
  input [2:0] r,
  output [2:0] g
);

// Define the states
enum logic [1:0] {
  A = 2'b00,
  B = 2'b01,
  C = 2'b10,
  D = 2'b11
} state, next_state;

// State table
always_comb begin
  case (state)
    A: begin
      if (r[0] == 1'b1) next_state = B;
      else if (r[1] == 1'b1) next_state = C;
      else if (r[2] == 1'b1) next_state = D;
      else next_state = A;
    end
    B: begin
      if (r[0] == 1'b1) next_state = B;
      else next_state = A;
    end
    C: begin
      if (r[1] == 1'b1) next_state = C;
      else next_state = A;
    end
    D: begin
      next_state = A;
    end
    default: next_state = A;
  endcase
end

// State flip-flops
always_ff @(posedge clk) begin
  if (~resetn) state <= A;
  else state <= next_state;
end

// Output signals
assign g[0] = (state == B) ? 1'b1 : 1'b0;
assign g[1] = (state == C) ? 1'b1 : 1'b0;
assign g[2] = (state == D) ? 1'b1 : 1'b0;

endmodule