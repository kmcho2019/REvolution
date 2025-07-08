module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  integer i;
  reg [511:0] next_q;

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      for (i = 0; i < 512; i = i + 1) begin
        // Define neighbors, with boundaries assumed zero
        // Left neighbor: q[i+1] if i < 511 else 0
        // Center: q[i]
        // Right neighbor: q[i-1] if i > 0 else 0
        // We'll assemble a 3-bit vector: {left, center, right}
        // Then apply Rule 110: next state = rule110[{left, center, right}]
        // Rule 110 bits for input ABC (left=center, center=center, right=right) =
        // Input (A B C) : output
        // 111(7) : 0
        // 110(6) : 1
        // 101(5) : 1
        // 100(4) : 0
        // 011(3) : 1
        // 010(2) : 1
        // 001(1) : 1
        // 000(0) : 0
        // So, the rule in binary indexed by {left,center,right} is:
        // bit position: 7 6 5 4 3 2 1 0
        // bit value:    0 1 1 0 1 1 1 0  -> 8'b01101110 = 8'h6E

        // Extract neighbors
        reg left, center, right;
        reg [2:0] neighborhood;
        left = (i < 511) ? q[i+1] : 1'b0;
        center = q[i];
        right = (i > 0) ? q[i-1] : 1'b0;
        neighborhood = {left, center, right};
        next_q[i] = 8'h6E[neighborhood];
      end
      q <= next_q;
    end
  end

endmodule