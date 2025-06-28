module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

// Define the states
parameter A = 1'b0;
parameter B = 1'b1;
reg state, next_state;

// Moore machine outputs
always @*
begin
  case(state)
    A: out = 1'b0;
    B: out = 1'b1;
  endcase
end

// State transition and output logic
always @(posedge clk or posedge areset)
begin
  if (areset) begin
    state <= B;  // Reset to state B
  end
  else begin
    case(state)
      A: next_state = in ? A : B;
      B: next_state = in ? B : A;
    endcase
    state <= next_state;
  end
end

endmodule