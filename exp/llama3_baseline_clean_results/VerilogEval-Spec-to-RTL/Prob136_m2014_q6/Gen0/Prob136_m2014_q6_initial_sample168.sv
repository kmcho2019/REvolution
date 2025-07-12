`define STATE_WIDTH 3

module TopModule (
  input  clk,
  input  reset,
  input  w,
  output z
);

typedef enum logic [`STATE_WIDTH-1:0] {
  A = 3'b000,
  B = 3'b001,
  C = 3'b010,
  D = 3'b011,
  E = 3'b100,
  F = 3'b101
} state_t;

state_t state, next_state;

always_ff @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

always_comb begin
  next_state = state;
  z = 1'b0; // Default output
  case (state)
    A: begin
      if (~w) next_state = B;
    end
    B: begin
      if (~w) next_state = C;
      else    next_state = D;
    end
    C: begin
      if (~w) next_state = E;
      else    next_state = D;
    end
    D: begin
      if (~w) next_state = F;
      else    next_state = A;
    end
    E: begin
      z = w;
      if (w) next_state = D;
      else   next_state = E;
    end
    F: begin
      z = w;
      if (~w) next_state = C;
      else    next_state = D;
    end
  endcase
end

endmodule