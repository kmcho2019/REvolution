module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

// Define the state register
reg [2:0] state;

// Define the next state logic
always @ (posedge clk) begin
  if (a) begin
    state <= state + 1;
  end
end

// Output q is the state
assign q = state;

endmodule