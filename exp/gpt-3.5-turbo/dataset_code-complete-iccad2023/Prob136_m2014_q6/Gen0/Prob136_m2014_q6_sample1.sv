module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

// State declaration
parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;
reg [2:0] state, next_state;

// State transition logic
always @(posedge clk) begin
  if (reset) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

always @(*) begin
  case(state)
    A: begin
      if (w) next_state = A; // Stay in A on input '1'
      else next_state = B; // Transition to B on input '0'
    end
    B: begin
      if (w) next_state = D; // Transition to D on input '1'
      else next_state = C; // Transition to C on input '0'
    end
    C: begin
      if (w) next_state = D; // Transition to D on input '1'
      else next_state = E; // Transition to E on input '0'
    end
    D: begin
      if (w) next_state = A; // Transition to A on input '1'
      else next_state = F; // Transition to F on input '0'
    end
    E: begin
      if (w) next_state = D; // Transition to D on input '1'
      else next_state = E; // Stay in E on input '0'
    end
    F: begin
      if (w) next_state = D; // Transition to D on input '1'
      else next_state = C; // Transition to C on input '0'
    end
    default: next_state = A;
  endcase
end

// Output
assign z = (state == E || state == F);

endmodule