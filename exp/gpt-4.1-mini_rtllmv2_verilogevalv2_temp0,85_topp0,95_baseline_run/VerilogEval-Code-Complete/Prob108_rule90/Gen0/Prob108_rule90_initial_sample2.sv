module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  // Next state wire
  wire [511:0] next_q;

  genvar i;
  generate
    for (i = 0; i < 512; i = i + 1) begin : rule90_gen
      // left neighbor: q[i-1], zero if i==0
      wire left = (i == 0) ? 1'b0 : q[i-1];
      // right neighbor: q[i+1], zero if i==511
      wire right = (i == 511) ? 1'b0 : q[i+1];

      assign next_q[i] = left ^ right;
    end
  endgenerate

  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= next_q;
  end

endmodule