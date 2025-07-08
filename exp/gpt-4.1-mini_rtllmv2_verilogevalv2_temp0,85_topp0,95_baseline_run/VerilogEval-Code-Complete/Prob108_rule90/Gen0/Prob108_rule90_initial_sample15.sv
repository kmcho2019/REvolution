module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  wire [511:0] left_shift;
  wire [511:0] right_shift;
  wire [511:0] next_q;

  // For left neighbors: shift q right by 1, pad left boundary with 0
  assign left_shift = {q[510:0], 1'b0};

  // For right neighbors: shift q left by 1, pad right boundary with 0
  assign right_shift = {1'b0, q[511:1]};

  // Next state is XOR of left and right neighbors for each cell
  assign next_q = left_shift ^ right_shift;

  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= next_q;
  end

endmodule