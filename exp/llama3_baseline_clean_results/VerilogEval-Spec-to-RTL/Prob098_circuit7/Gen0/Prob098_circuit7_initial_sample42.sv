module TopModule(
  input clk,
  input a,
  output q
);

reg q_reg;

initial q_reg = 1'b1; // initial output value based on waveform

always @(posedge clk)
  if (a) 
    q_reg = ~q_reg; // toggle the output

assign q = q_reg;

endmodule