module TopModule (
  input clk,
  input x,
  output z
);

  reg Q1, Q2, Q3;

  // Initialize flip-flops to zero on start
  initial begin
    Q1 = 0;
    Q2 = 0;
    Q3 = 0;
  end

  wire d1, d2, d3;

  assign d1 = x ^ Q1;     // XOR with Q1
  assign d2 = x & ~Q2;    // AND with ~Q2
  assign d3 = x | ~Q3;    // OR with ~Q3

  always @(posedge clk) begin
    Q1 <= d1;
    Q2 <= d2;
    Q3 <= d3;
  end

  assign z = ~(Q1 | Q2 | Q3); // 3-input NOR

endmodule