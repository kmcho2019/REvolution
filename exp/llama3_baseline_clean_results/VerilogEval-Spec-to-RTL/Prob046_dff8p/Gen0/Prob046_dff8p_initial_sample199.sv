module DFF(clk, reset, d, q);
  input clk, reset;
  input d;
  output q;
  reg q;

  always @(posedge reset or negedge clk) begin
    if (reset) begin
      q <= 1'b0; // This will be overwritten by the initial block in TopModule
    end else begin
      q <= d;
    end
  end
endmodule

module TopModule(clk, reset, d, q);
  input clk, reset;
  input [7:0] d;
  output [7:0] q;

  wire [7:0] q_int;

  assign q = q_int;

  DFF dff0(clk, reset, d[0], q_int[0]);
  DFF dff1(clk, reset, d[1], q_int[1]);
  DFF dff2(clk, reset, d[2], q_int[2]);
  DFF dff3(clk, reset, d[3], q_int[3]);
  DFF dff4(clk, reset, d[4], q_int[4]);
  DFF dff5(clk, reset, d[5], q_int[5]);
  DFF dff6(clk, reset, d[6], q_int[6]);
  DFF dff7(clk, reset, d[7], q_int[7]);

  initial begin
    q_int <= 8'h34; // Initial value
  end
endmodule