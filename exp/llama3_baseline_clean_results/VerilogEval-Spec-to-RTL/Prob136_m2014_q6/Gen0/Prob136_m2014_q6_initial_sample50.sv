module TopModule(
  input  clk,
  input  reset,
  input  w,
  output z
);

// Define the states as an enumerated type
enum logic [2:0] {
  A = 3'b000,
  B = 3'b001,
  C = 3'b010,
  D = 3'b011,
  E = 3'b100,
  F = 3'b101
} state, next_state;

// Assign the output based on the current state
always_comb begin
  case (state)
    A: z = 0;
    B: z = 0;
    C: z = 0;
    D: z = 0;
    E: z = 1;
    F: z = 1;
    default: z = 0;
  endcase
end

// Determine the next state based on the current state and input
always_comb begin
  case (state)
    A: next_state = w? A : B;
    B: next_state = w? D : C;
    C: next_state = w? D : E;
    D: next_state = w? A : F;
    E: next_state = w? D : E;
    F: next_state = w? D : C;
    default: next_state = A;
  endcase
end

// Sequential logic to update the state on the positive edge of the clock
always_ff @(posedge clk) begin
  if (reset) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

endmodule