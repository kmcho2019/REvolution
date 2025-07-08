module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  reg [511:0] next_q;

  // Compute next state for each cell according to Rule 110
  integer i;
  always @* begin
    for (i = 0; i < 512; i = i + 1) begin
      // Get left, center, right neighbors, with boundaries assumed zero
      // left = q[i+1] if i < 511 else 0
      // right = q[i-1] if i > 0 else 0
      // center = q[i]
      reg left, center, right;
      left = (i < 511) ? q[i+1] : 1'b0;
      center = q[i];
      right = (i > 0) ? q[i-1] : 1'b0;

      // Apply Rule 110 mapping from (left, center, right) to next state:
      // The pattern bits form a 3-bit number: {left, center, right}
      // Index rule bits by that 3-bit number:
      // Rule 110 binary: 01101110 (bit 7 is 0, bit 0 is 0)
      // bit pos: 7 6 5 4 3 2 1 0
      // value:   0 1 1 0 1 1 1 0
      // next state = rule110[{left,center,right}]
      case ({left, center, right})
        3'b111: next_q[i] = 1'b0;
        3'b110: next_q[i] = 1'b1;
        3'b101: next_q[i] = 1'b1;
        3'b100: next_q[i] = 1'b0;
        3'b011: next_q[i] = 1'b1;
        3'b010: next_q[i] = 1'b1;
        3'b001: next_q[i] = 1'b1;
        3'b000: next_q[i] = 1'b0;
      endcase
    end
  end

  // Synchronous update
  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= next_q;
  end

endmodule