module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

// Define one-hot encoded states
reg [3:0] state;
reg [3:0] next_state;

// Define one-hot encoded state constants
localparam A = 4'b0001;
localparam B = 4'b0010;
localparam C = 4'b0100;
localparam D = 4'b1000;

// Combinational logic for next state
always @(*) begin
  case (1'b1 ? (state[A] ? in ? B : A) : 
                   (state[B] ? in ? B : C) : 
                   (state[C] ? in ? D : A) : 
                   (state[D] ? in ? B : C)))
    A: next_state = in ? B : A;
    B: next_state = in ? B : C;
    C: next_state = in ? D : A;
    D: next_state = in ? B : C;
    default: next_state = A; // Default state
  endcase
end

// However, this way of writing next state logic is overly complicated, so 
// we can simplify it and use 'assign' for better readability
assign next_state[A] = (~areset && clk) ? (state[A] && !in) || (state[C] && !in) : 1'b0;
assign next_state[B] = (~areset && clk) ? (state[A] && in) || (state[B] && in) || (state[D] && in) : 1'b0;
assign next_state[C] = (~areset && clk) ? (state[B] && !in) || (state[D] && !in) : 1'b0;
assign next_state[D] = (~areset && clk) ? (state[C] && in) : 1'b0;

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

// Output logic
assign out = state[D];

endmodule