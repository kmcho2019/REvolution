module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  // Function to compute next state of a single cell given left, center, right bits
  function automatic logic next_state(input logic left, input logic center, input logic right);
    begin
      // Rule 110 as per truth table:
      // Inputs: left center right
      // 111 -> 0
      // 110 -> 1
      // 101 -> 1
      // 100 -> 0
      // 011 -> 1
      // 010 -> 1
      // 001 -> 1
      // 000 -> 0
      next_state = (left & center & right) ? 1'b0 :
                   (left & center & ~right) ? 1'b1 :
                   (left & ~center & right) ? 1'b1 :
                   (left & ~center & ~right) ? 1'b0 :
                   (~left & center & right) ? 1'b1 :
                   (~left & center & ~right) ? 1'b1 :
                   (~left & ~center & right) ? 1'b1 :
                   1'b0;
    end
  endfunction

  integer i;
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      logic [511:0] next_q;
      for (i = 0; i < 512; i = i + 1) begin
        // left neighbor: q[i+1] if i < 511 else 0
        logic left = (i < 511) ? q[i+1] : 1'b0;
        // center: q[i]
        logic center = q[i];
        // right neighbor: q[i-1] if i > 0 else 0
        logic right = (i > 0) ? q[i-1] : 1'b0;
        next_q[i] = next_state(left, center, right);
      end
      q <= next_q;
    end
  end

endmodule