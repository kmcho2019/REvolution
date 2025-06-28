module TopModule (
  input clk,
  input in,
  output logic out
);

  logic xor_input;
  logic xor_output;
  
  assign xor_input = in ^ out;
  
  DFF dff (
    .clk(clk),
    .d(xor_output),
    .q(out)
  );
  
  always_comb begin
    xor_output = xor_input;
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