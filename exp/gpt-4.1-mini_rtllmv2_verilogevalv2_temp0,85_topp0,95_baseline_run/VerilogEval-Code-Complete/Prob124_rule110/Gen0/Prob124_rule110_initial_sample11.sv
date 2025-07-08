module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  // Wire to hold next state
  reg [511:0] next_q;

  integer i;
  always @(*) begin
    for (i = 0; i < 512; i = i + 1) begin
      // Get neighbors, with boundary cells assumed zero
      // left = q[i+1] if i < 511 else 0
      // center = q[i]
      // right = q[i-1] if i > 0 else 0
      // Note: The problem states Left[i+1], Center[i], Right[i-1], indexing as such.

      // left neighbor: q[i+1] if i<511 else 0
      // center: q[i]
      // right: q[i-1] if i>0 else 0
      // Using these, form the 3-bit pattern and apply Rule 110.

      // Extract neighbors
      reg left, center, right;
      left = (i < 511) ? q[i+1] : 1'b0;
      center = q[i];
      right = (i > 0) ? q[i-1] : 1'b0;

      // Combine neighbors to form index for rule lookup: {left, center, right}
      // Rule 110: next_state = 0b01101110 (binary) for patterns 111..000 as index 7..0
      // Index = {left, center, right} as a 3-bit number
      // The bit position to select is index (from 7 down to 0)
      // The rule bits for Rule 110: 
      // pattern: 111 110 101 100 011 010 001 000
      // next:     0   1   1   0   1   1   1   0
      // Binary: 0b01101110 == 8'h6E

      // Compute index
      reg [2:0] idx;
      idx = {left, center, right};

      // Apply rule
      next_q[i] = 8'h6E[idx];
    end
  end

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      q <= next_q;
    end
  end

endmodule