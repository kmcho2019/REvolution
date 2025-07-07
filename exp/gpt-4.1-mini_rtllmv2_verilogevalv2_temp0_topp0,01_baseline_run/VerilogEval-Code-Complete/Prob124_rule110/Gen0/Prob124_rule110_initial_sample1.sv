module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  // Function to compute next state of a cell given left, center, right bits
  function automatic logic rule110;
    input logic left, center, right;
    begin
      // According to the rule table:
      // next = (left & center & right) ? 0 :
      //        (left & center & ~right) ? 1 :
      //        (left & ~center & right) ? 1 :
      //        (left & ~center & ~right) ? 0 :
      //        (~left & center & right) ? 1 :
      //        (~left & center & ~right) ? 1 :
      //        (~left & ~center & right) ? 1 :
      //        (~left & ~center & ~right) ? 0 : 0;
      // This can be simplified by the rule 110 bit pattern: 01101110 (binary)
      // The 3-bit input is (left, center, right), interpreted as a 3-bit number:
      // index = {left, center, right}
      // rule110 = bit at position index of 8'b01101110 (LSB is index 0)
      // Index mapping:
      // 111(7) -> 0
      // 110(6) -> 1
      // 101(5) -> 1
      // 100(4) -> 0
      // 011(3) -> 1
      // 010(2) -> 1
      // 001(1) -> 1
      // 000(0) -> 0
      logic [7:0] rule = 8'b01101110;
      rule110 = rule[{left, center, right}];
    end
  endfunction

  integer i;
  reg [511:0] next_q;

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Compute next state for each cell
      for (i = 0; i < 512; i = i + 1) begin
        // Determine neighbors with boundary conditions
        logic left = (i == 511) ? 1'b0 : q[i+1];
        logic center = q[i];
        logic right = (i == 0) ? 1'b0 : q[i-1];
        next_q[i] = rule110(left, center, right);
      end
      q <= next_q;
    end
  end

endmodule