module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

reg [1:0] state; // Use a reg for the current state
reg [1:0] next_state; // Temporary reg for next state calculation

always @(*) begin
  case (state)
    2'd0: next_state = in ? 2'd1 : 2'd0; // Directly implement state transitions
    2'd1: next_state = in ? 2'd1 : 2'd2;
    2'd2: next_state = in ? 2'd3 : 2'd0;
    2'd3: next_state = in ? 2'd1 : 2'd2;
    default: next_state = 2'd0; // Default to state A if state is invalid
  endcase
end

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 2'd0; // Asynchronous reset to state A
  end else begin
    state <= next_state; // Update state on positive clock edge
  end
end

assign out = (state == 2'd3); // Directly assign output based on current state

endmodule