module TopModule(clk, x, z);
  input clk;
  input x;
  output z;
  reg [2:0] ff_out;
  wire [2:0] gate_out;

  assign gate_out[0] = x ^ ff_out[0];
  assign gate_out[1] = x & ~ff_out[1];
  assign gate_out[2] = x | ~ff_out[2];

  always @(posedge clk) begin
    ff_out[0] <= gate_out[0];
    ff_out[1] <= gate_out[1];
    ff_out[2] <= gate_out[2];
  end

  assign z = ~(gate_out[0] | gate_out[1] | gate_out[2]);

  initial begin
    ff_out = 3'b000;
  end

endmodule