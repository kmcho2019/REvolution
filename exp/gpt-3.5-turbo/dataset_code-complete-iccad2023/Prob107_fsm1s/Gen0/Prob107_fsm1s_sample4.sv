module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

// Define possible states
parameter B = 1'b0;
parameter A = 1'b1;

// State register
reg state, next_state;

// Output register
reg out_reg;

// Moore state machine logic
always @(posedge clk) begin
  if (reset) begin
    state <= B;
    out_reg <= 1'b1;
  end else begin
    state <= next_state;
    out_reg <= state;
  end
end

// State transition logic
always @(*) begin
  case(state)
    B: next_state = (in) ? B : A;
    A: next_state = (in) ? A : B;
    default: next_state = B;
  endcase
end

// Output assignment
assign out = out_reg;

endmodule