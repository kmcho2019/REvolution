module TopModule(d, ena, q);
  input d;
  input ena;
  output reg q;
  reg master_q; // Intermediate storage for master latch

  // Master latch
  always @(posedge ena) begin
    master_q <= d;
  end

  // Slave latch
  always @(negedge ena) begin
    q <= master_q;
  end
endmodule