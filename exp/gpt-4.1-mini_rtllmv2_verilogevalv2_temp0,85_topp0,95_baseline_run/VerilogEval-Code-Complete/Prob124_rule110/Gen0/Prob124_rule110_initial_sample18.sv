module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  integer i;
  reg [511:0] next_q;

  // Function to compute next state of a cell based on left, center, right bits
  // According to Rule 110 table:
  // left center right | next
  // 111 -> 0
  // 110 -> 1
  // 101 -> 1
  // 100 -> 0
  // 011 -> 1
  // 010 -> 1
  // 001 -> 1
  // 000 -> 0
  // next = (~left & center) | (left & ~center & right) | (center & ~right);
  // This is the Boolean equation derived from the table.

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      for (i = 0; i < 512; i = i + 1) begin
        // Define neighbors with boundary zeros
        // left = q[i+1] if i < 511 else 0
        // center = q[i]
        // right = q[i-1] if i > 0 else 0
        // Note indexing carefully: q[511:0], left neighbor is higher index, right neighbor lower index
        // For i=511, left = 0; for i=0, right = 0

        reg left, center, right;
        left = (i < 511) ? q[i+1] : 1'b0;
        center = q[i];
        right = (i > 0) ? q[i-1] : 1'b0;

        next_q[i] = (~left & center) | (left & ~center & right) | (center & ~right);
      end
      q <= next_q;
    end
  end
endmodule