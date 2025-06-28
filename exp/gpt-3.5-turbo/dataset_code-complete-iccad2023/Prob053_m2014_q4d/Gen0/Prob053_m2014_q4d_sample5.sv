module TopModule (
  input clk,
  input in,
  output logic out
);

  logic xor_output;
  DFF dff (
    .clk(clk),
    .d(xor_output),
    .q(out)
  );
  
  assign xor_output = in ^ out;
  
  always @(posedge clk) begin
    out <= xor_output;
  end

endmodule

module DFF (
  input clk,
  input d,
  output reg q
);
  
  always @(posedge clk) begin
    q <= d;
  end

endmodule