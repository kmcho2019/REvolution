module TopModule (
  input clk,
  input x,
  output z
);

  reg Q1, Q2, Q3;

  // Combinational logic for D inputs
  wire D1, D2, D3;
  assign D1 = x ^ Q1;
  assign D2 = x & (~Q2);
  assign D3 = x | (~Q3);

  // Sequential logic for flip-flops with asynchronous reset to zero at start
  initial begin
    Q1 = 0;
    Q2 = 0;
    Q3 = 0;
  end

  always @(posedge clk) begin
    Q1 <= D1;
    Q2 <= D2;
    Q3 <= D3;
  end

  // Output z is NOR of Q1, Q2, and Q3
  assign z = ~(Q1 | Q2 | Q3);

endmodule