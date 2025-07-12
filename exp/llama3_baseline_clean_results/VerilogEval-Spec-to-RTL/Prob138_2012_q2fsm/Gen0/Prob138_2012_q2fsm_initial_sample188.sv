module TopModule(
  input  clk,
  input  reset,
  input  w,
  output z
);

// Define states and assign codes
typedef enum logic [2:0] {
  A = 3'b001,
  B = 3'b010,
  C = 3'b011,
  D = 3'b100,
  E = 3'b101,
  F = 3'b110
} states;

states current_state, next_state;

// State flip-flops
always_ff @(posedge clk) begin
  if (reset) begin
    current_state <= A;
  end else begin
    current_state <= next_state;
  end
end

// State table
always_comb begin
  case (current_state)
    A: next_state = w ? B : A;
    B: next_state = w ? C : D;
    C: next_state = w ? E : D;
    D: next_state = w ? F : A;
    E: next_state = w ? E : D;
    F: next_state = w ? C : D;
    default: next_state = A; // default to state A
  endcase
end

// FSM output 'z'
always_comb begin
  case (current_state)
    A, B, C, D: z = 0;
    E, F: z = 1;
    default: z = 0; // default to 0
  endcase
end

endmodule