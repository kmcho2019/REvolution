module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  // Function to compute next state of a cell given its 3 neighbors
  // Rule 110 truth table:
  // L C R | Next
  // 111 -> 0
  // 110 -> 1
  // 101 -> 1
  // 100 -> 0
  // 011 -> 1
  // 010 -> 1
  // 001 -> 1
  // 000 -> 0
  //
  // Next state = (~L & C) | (C & ~R) | (L & ~C & ~R)
  // From the table logic simplification:
  // The exact expression is:
  // next = ( (L & ~C & ~R) | (~L & C) | (C & ~R) );
  //
  // We will implement this logic.

  integer i;
  reg [511:0] next_q;

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      for (i = 0; i < 512; i = i + 1) begin
        // Get neighbors with boundary = 0
        // Left neighbor q[i+1] or 0 if i=511
        // Center q[i]
        // Right neighbor q[i-1] or 0 if i=0
        wire L = (i == 511) ? 1'b0 : q[i+1];
        wire C = q[i];
        wire R = (i == 0) ? 1'b0 : q[i-1];

        next_q[i] = (L & ~C & ~R) | (~L & C) | (C & ~R);
      end
      q <= next_q;
    end
  end

endmodule