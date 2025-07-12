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

// Sequential logic for state update with asynchronous reset and next-state logic
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= A;
  end else begin
    case (state)
      A: state <= in? B : A;
      B: state <= in? B : C;
      C: state <= in? D : A;
      D: state <= in? B : C;
      default: state <= A;
    endcase
  end
end

// Output logic
assign out = (state == D)? 1'b1 : 1'b0;

endmodule