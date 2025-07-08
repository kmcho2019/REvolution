module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  // Rule 110 lookup: index is {left, center, right}
  // rule110[7:0] = 8'b01101110;
  // Index 7 (111): 0
  // Index 6 (110): 1
  // Index 5 (101): 1
  // Index 4 (100): 0
  // Index 3 (011): 1
  // Index 2 (010): 1
  // Index 1 (001): 1
  // Index 0 (000): 0

  wire [7:0] rule110 = 8'b01101110;

  integer i;
  reg [511:0] next_q;

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Compute next_q according to Rule 110
      for (i = 0; i < 512; i = i + 1) begin
        // Left neighbor q[i+1], 0 if out of range
        // Center q[i]
        // Right neighbor q[i-1], 0 if out of range
        // Compose 3-bit index: {left, center, right}
        reg left, center, right;
        left = (i == 511) ? 1'b0 : q[i+1];
        center = q[i];
        right = (i == 0) ? 1'b0 : q[i-1];
        next_q[i] = rule110[{left, center, right}];
      end
      q <= next_q;
    end
  end
endmodule