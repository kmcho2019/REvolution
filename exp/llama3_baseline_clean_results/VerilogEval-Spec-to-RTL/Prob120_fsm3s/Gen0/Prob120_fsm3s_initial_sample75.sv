module TopModule(
  input         clk,
  input         reset,
  input         in,
  output logic  out
);

// Define the states
localparam A = 0;
localparam B = 1;
localparam C = 2;
localparam D = 3;

// State register declaration
logic [1:0] state, next_state;

// State register
always_ff @(posedge clk) begin
  if (reset) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

// Next state logic
always_comb begin
  case (state)
    A: next_state = in ? B : A;
    B: next_state = in ? B : C;
    C: next_state = in ? D : A;
    D: next_state = in ? B : C;
    default: next_state = A;
  endcase
end

// Output logic
always_comb begin
  case (state)
    A, B, C: out = 0;
    D: out = 1;
    default: out = 0;
  endcase
end

endmodule