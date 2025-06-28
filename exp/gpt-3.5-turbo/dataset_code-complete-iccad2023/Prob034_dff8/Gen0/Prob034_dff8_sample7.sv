module DFF (
  input clk,
  input d,
  output reg q
);

always @(posedge clk)
  q <= d;

endmodule

module TopModule (
  input clk,
  input [7:0] d,
  output reg [7:0] q
);

reg [7:0] q_reg;

DFF dff[7:0] (
  .clk(clk),
  .d(d[0]),
  .q(q_reg[0])
);

generate
  genvar i;
  for (i = 1; i < 8; i = i + 1) begin : gen_dff
    DFF dff_inst (
      .clk(clk),
      .d(d[i]),
      .q(q_reg[i])
    );
  end
endgenerate

assign q = q_reg;

endmodule