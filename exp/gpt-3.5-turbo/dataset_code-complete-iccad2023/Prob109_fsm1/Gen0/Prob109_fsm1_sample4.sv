module TopModule (
  input clk,    // Clock input
  input in,     // Input signal
  input areset, // Asynchronous reset input
  output reg out // Output signal
);

// Define states
parameter A = 1'b0;
parameter B = 1'b1;

// State register
reg state, next_state;

// Next state logic
always @(*) begin
  case(state)
    A: next_state = in ? A : B;
    B: next_state = in ? B : A;
  endcase
end

// State and output logic
always @(posedge clk or posedge areset) begin
  if(areset) begin
    state <= B;
  end else begin
    state <= next_state;
  end

  out <= state;
end

endmodule