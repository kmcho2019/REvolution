module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  // Function to compute the next state of a cell based on left, center, right
  function automatic bit rule110;
    input bit left, center, right;
    begin
      // According to the truth table:
      // Next state is 1 except when (111), (100), (000)
      // From the table:
      // (111) -> 0
      // (110) -> 1
      // (101) -> 1
      // (100) -> 0
      // (011) -> 1
      // (010) -> 1
      // (001) -> 1
      // (000) -> 0

      // Let's implement as:
      // next = (~left & center) | (center & ~right) | (left & ~center & right);
      // Or directly from the combinations:

      rule110 = ((left == 1'b1) && (center == 1'b1) && (right == 1'b1)) ? 1'b0 : 
                ((left == 1'b1) && (center == 1'b1) && (right == 1'b0)) ? 1'b1 :
                ((left == 1'b1) && (center == 1'b0) && (right == 1'b1)) ? 1'b1 :
                ((left == 1'b1) && (center == 1'b0) && (right == 1'b0)) ? 1'b0 :
                ((left == 1'b0) && (center == 1'b1) && (right == 1'b1)) ? 1'b1 :
                ((left == 1'b0) && (center == 1'b1) && (right == 1'b0)) ? 1'b1 :
                ((left == 1'b0) && (center == 1'b0) && (right == 1'b1)) ? 1'b1 :
                1'b0;
    end
  endfunction

  integer i;
  reg [511:0] q_next;

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Compute next state for each cell
      for (i = 0; i < 512; i = i + 1) begin
        // left neighbor: i+1, right neighbor: i-1
        // Boundary conditions: q[-1] = 0, q[512] = 0
        bit left, center, right;
        left   = (i == 511) ? 1'b0 : q[i+1];
        center = q[i];
        right  = (i == 0)   ? 1'b0 : q[i-1];
        q_next[i] = rule110(left, center, right);
      end
      q <= q_next;
    end
  end

endmodule