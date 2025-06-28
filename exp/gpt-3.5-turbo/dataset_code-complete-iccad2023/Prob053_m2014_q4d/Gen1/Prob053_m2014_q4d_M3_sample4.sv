module TopModule (
    input clk,
    input in,
    output logic out
);

  logic d_ff;
  always_ff @(posedge clk)
    d_ff <= in ^ out;

  assign out = d_ff;

endmodule