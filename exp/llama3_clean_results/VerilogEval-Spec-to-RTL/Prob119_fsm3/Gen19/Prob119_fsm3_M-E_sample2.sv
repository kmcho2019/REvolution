module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

// Define states using binary encoding
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define the state register
reg [1:0] state;
reg [1:0] next_state;

// Define the output register
reg out_reg;

// Combinational logic for next state
always @(*) begin
  case (state)
    A: next_state = in? B : A;
    B: next_state = in? B : C;
    C: next_state = in? D : A;
    D: next_state = in? B : C;
    default: next_state = A;
  endcase
end

// Combinational logic for output
always @(*) begin
  case (state)
    A: out_reg = 0;
    B: out_reg = 0;
    C: out_reg = 0;
    D: out_reg = 1;
    default: out_reg = 0;
  endcase
end

// Sequential logic for state update with asynchronous reset
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= A;
    out_reg <= 0;
  end else begin
    state <= next_state;
    out_reg <= out_reg; // Update output register
  end
end

// Output logic
assign out = out_reg;

endmodule