module DFF (
  input clk,
  input d,
  output reg q
);

  always @(posedge clk) begin
    q <= d;
  end

endmodule

module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

  reg d;
  wire [2:0] dff_out;

  assign dff_out = {q[1:0], a};

  DFF dff_inst (
    .clk(clk),
    .d(d),
    .q(q[0])
  );

  always @* begin
    if (a == 0)
      d = dff_out[2];
  end

endmodule