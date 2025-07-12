module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

// Define states using one-hot encoding
localparam A = 1'b1;
localparam B = 1'b10;
localparam C = 1'b100;
localparam D = 1'b1000;

// Define the state register
reg [3:0] state;
reg [3:0] next_state;

// Combinational logic for next state
always @(state or in) begin
  case (1'b1)
    state[0]: next_state = in ? B : A;
    state[1]: next_state = in ? B : C;
    state[2]: next_state = in ? D : A;
    state[3]: next_state = in ? B : C;
    default: next_state = A; // Default state
  endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

// Output logic
assign out = (state == D) ? 1 : 0;

endmodule