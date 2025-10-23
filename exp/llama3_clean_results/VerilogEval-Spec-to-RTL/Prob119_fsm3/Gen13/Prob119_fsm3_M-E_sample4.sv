module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

// Define one-hot encoded states
reg [3:0] state;
reg [3:0] next_state;

// One-hot encoded states
parameter A = 4'b0001;
parameter B = 4'b0010;
parameter C = 4'b0100;
parameter D = 4'b1000;

// Sequential logic for state update with asynchronous reset
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

// Combinational logic for next state
always @(*) begin
  case (1'b1)
    state[0]: next_state = in ? B : A;
    state[1]: next_state = in ? B : C;
    state[2]: next_state = in ? D : A;
    state[3]: next_state = in ? B : C;
    default: next_state = A;
  endcase
end

// Output logic
assign out = state[3] ? 1'b1 : 1'b0;

endmodule