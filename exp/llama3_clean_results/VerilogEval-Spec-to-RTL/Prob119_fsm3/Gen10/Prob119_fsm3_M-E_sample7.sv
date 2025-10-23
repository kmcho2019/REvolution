module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

// Define the one-hot encoded signal
reg [3:0] state;
reg [3:0] next_state;

// Combinational logic for next state
always @(*) begin
  case (state)
    4'b0001: next_state = in? 4'b0010 : 4'b0001; // State A
    4'b0010: next_state = in? 4'b0010 : 4'b0100; // State B
    4'b0100: next_state = in? 4'b1000 : 4'b0001; // State C
    4'b1000: next_state = in? 4'b0010 : 4'b0100; // State D
    default: next_state = 4'b0001; // Default state
  endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 4'b0001;
  end else begin
    state <= next_state;
  end
end

// Output logic
assign out = state[3]; // Output is 1 when in state D

endmodule