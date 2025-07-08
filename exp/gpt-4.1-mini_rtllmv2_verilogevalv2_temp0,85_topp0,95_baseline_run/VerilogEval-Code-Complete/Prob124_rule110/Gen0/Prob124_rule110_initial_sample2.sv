module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  reg [511:0] next_q;

  integer i;
  always @* begin
    for (i = 0; i < 512; i = i + 1) begin
      // Determine neighbors with zero boundary conditions
      // left = q[i+1] if i<511 else 0
      // right = q[i-1] if i>0 else 0
      reg left, center, right;
      left = (i < 511) ? q[i+1] : 1'b0;
      center = q[i];
      right = (i > 0) ? q[i-1] : 1'b0;

      // Apply Rule 110:
      // Rule 110 binary: 01101110 for (left,center,right) in order 111,110,...000
      // We can encode the rule as a function of the 3-bit input:
      // Index bits as {left, center, right} as 3-bit number
      // Let's define the rule in a lookup table:
      // 111 -> 0
      // 110 -> 1
      // 101 -> 1
      // 100 -> 0
      // 011 -> 1
      // 010 -> 1
      // 001 -> 1
      // 000 -> 0

      case ({left, center, right})
        3'b111: next_q[i] = 1'b0;
        3'b110: next_q[i] = 1'b1;
        3'b101: next_q[i] = 1'b1;
        3'b100: next_q[i] = 1'b0;
        3'b011: next_q[i] = 1'b1;
        3'b010: next_q[i] = 1'b1;
        3'b001: next_q[i] = 1'b1;
        3'b000: next_q[i] = 1'b0;
        default: next_q[i] = 1'b0; // Default case for safety
      endcase
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