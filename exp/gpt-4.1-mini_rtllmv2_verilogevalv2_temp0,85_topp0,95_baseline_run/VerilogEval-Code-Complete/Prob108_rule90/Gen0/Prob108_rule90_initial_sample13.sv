module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  wire [511:0] next_q;

  assign next_q[0] = q[1]; // left neighbor of q[0] is 0, so next = 0 ^ q[1] = q[1]
  assign next_q[511] = q[510]; // right neighbor of q[511] is 0, so next = q[510] ^ 0 = q[510]

  genvar i;
  generate
    for (i = 1; i < 511; i = i + 1) begin : rule90
      assign next_q[i] = q[i-1] ^ q[i+1];
    end
  endgenerate

  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= next_q;
  end
endmodule