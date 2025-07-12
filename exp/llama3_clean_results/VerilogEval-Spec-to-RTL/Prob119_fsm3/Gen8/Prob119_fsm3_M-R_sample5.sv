module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

// Define states
parameter NUM_STATES = 4;
localparam A = 4'd1;
localparam B = 4'd2;
localparam C = 4'd4;
localparam D = 4'd8;

// Define the state register
reg [3:0] state;
reg [3:0] next_state;

// Combinational logic for next state
assign next_state = 
  (state == A && !in) ? A :
  (state == A && in)  ? B :
  (state == B && !in) ? C :
  (state == B && in)  ? B :
  (state == C && !in) ? A :
  (state == C && in)  ? D :
  (state == D && !in) ? C :
  (state == D && in)  ? B : A;

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

// Output logic
assign out = (state == D);

endmodule