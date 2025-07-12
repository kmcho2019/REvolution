module TopModule(
  input  clk,
  input  resetn,
  input  [2:0] r,
  output [2:0] g
);

reg [1:0] state, next_state;

// Next state logic
always @(*) begin
  case (state)
    2'b00: // State A
      if (~r[0] && ~r[1] && ~r[2]) begin
        next_state = 2'b00; // Stay in A if no requests
      end else if (r[0]) begin
        next_state = 2'b01; // Go to B if r0 is high
      end else if (r[1]) begin
        next_state = 2'b10; // Go to C if r0 is low and r1 is high
      end else begin
        next_state = 2'b11; // Go to D if r0 and r1 are low and r2 is high
      end
    2'b01: // State B
      if (r[0]) begin
        next_state = 2'b01; // Stay in B if r0 is high
      end else begin
        next_state = 2'b00; // Go to A if r0 is low
      end
    2'b10: // State C
      if (r[1]) begin
        next_state = 2'b10; // Stay in C if r1 is high
      end else begin
        next_state = 2'b00; // Go to A if r1 is low
      end
    2'b11: // State D
      if (~r[0] && ~r[1] && r[2]) begin
        next_state = 2'b11; // Stay in D if r2 is high
      end else begin
        next_state = 2'b00; // Go to A if r2 is low
      end
    default: next_state = 2'b00; // Default to state A
  endcase
end

// State flip-flops
always @(posedge clk) begin
  if (~resetn) begin
    state <= 2'b00; // Reset to state A
  end else begin
    state <= next_state; // Update current state
  end
end

// Output logic
assign g[0] = (state == 2'b01) || (state == 2'b01 && r[0]);
assign g[1] = (state == 2'b10) && r[1];
assign g[2] = (state == 2'b11) && r[2];

endmodule