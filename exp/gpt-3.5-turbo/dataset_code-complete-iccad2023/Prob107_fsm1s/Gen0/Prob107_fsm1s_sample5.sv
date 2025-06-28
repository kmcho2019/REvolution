module MooreStateMachine (
  input clk,
  input in,
  input reset,
  output reg out,
  
  // State encoding: B=0, A=1
  reg state, next_state;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= 2'b00; // Initialize to state B
    end else begin
      case(state)
        2'b00: next_state = in ? 2'b00 : 2'b01; // Transition based on input
        2'b01: next_state = in ? 2'b01 : 2'b00; // Transition based on input
        default: next_state = 2'b00; // Default state B
      endcase
      state <= next_state;
    end
  end
  
  always @(*) begin
    out = (state == 2'b00) ? 1 : 0; // Output based on current state
  end
endmodule

module TopModule (
  input clk,
  input in,
  input reset,
  output out
);

  MooreStateMachine fsm (
    .clk(clk),
    .in(in),
    .reset(reset),
    .out(out)
  );

endmodule