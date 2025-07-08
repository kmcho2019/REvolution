module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  integer i;
  reg [511:0] next_q;

  // Function to compute next state of a cell based on Rule 110
  function automatic bit rule110;
    input bit left, center, right;
    begin
      // According to the table, the next state is 1 unless the pattern is 111, 100, or 000
      // The rule can be expressed as:
      // next = (left & center & right) ? 0 :
      //        (left & ~center & ~right) ? 0 :
      //        (~left & ~center & ~right) ? 0 : 1;

      // Or, equivalently, the truth table in binary (left, center, right):
      // 111 -> 0
      // 110 -> 1
      // 101 -> 1
      // 100 -> 0
      // 011 -> 1
      // 010 -> 1
      // 001 -> 1
      // 000 -> 0
      // Can also be expressed by the formula: next = (left & center & ~right) | (left & ~center & right) | (~left & center & right) | (~left & center & ~right) | (~left & ~center & right);

      // For simplicity, implement this directly
      if (left && center && right)
        rule110 = 0;
      else if (left && ~center && ~right)
        rule110 = 0;
      else if (~left && ~center && ~right)
        rule110 = 0;
      else
        rule110 = 1;
    end
  endfunction

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      for (i = 0; i < 512; i = i + 1) begin
        // Determine neighbors with boundary conditions zero
        bit left = (i == 511) ? 0 : q[i+1];
        bit center = q[i];
        bit right = (i == 0) ? 0 : q[i-1];
        next_q[i] = rule110(left, center, right);
      end
      q <= next_q;
    end
  end

endmodule