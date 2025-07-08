module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Compute next state according to Rule 90
      // For cell 0, left neighbor = 0, right neighbor = q[1]
      // For cell 511, left neighbor = q[510], right neighbor = 0
      // For others, left = q[i-1], right = q[i+1]
      q <= {q[510:0] ^ q[512-1:1], 1'b0} ^ {1'b0, q[511:1]};
    end
  end

endmodule