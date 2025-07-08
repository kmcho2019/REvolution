module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  // Function to compute next state of a single cell using Rule 110
  function automatic bit rule110_cell(input bit left, input bit center, input bit right);
    begin
      // According to the table:
      // next = (left & center & right) ? 0 :
      //        (left & center & ~right) ? 1 :
      //        (left & ~center & right) ? 1 :
      //        (left & ~center & ~right) ? 0 :
      //        (~left & center & right) ? 1 :
      //        (~left & center & ~right) ? 1 :
      //        (~left & ~center & right) ? 1 :
      //        (~left & ~center & ~right) ? 0 ;
      //
      // This can be simplified as:
      // next = (left & center & right) ? 0 : 
      //        (left & center & ~right) ? 1 :
      //        (left & ~center & right) ? 1 :
      //        (left & ~center & ~right) ? 0 :
      //        (~left & center & right) ? 1 :
      //        (~left & center & ~right) ? 1 :
      //        (~left & ~center & right) ? 1 :
      //        0;
      //
      // Alternatively, from standard Rule 110 definition:
      // next = (left & center & right) ? 0 :
      //        (left & center & ~right) ? 1 :
      //        (left & ~center & right) ? 1 :
      //        (left & ~center & ~right) ? 0 :
      //        (~left & center & right) ? 1 :
      //        (~left & center & ~right) ? 1 :
      //        (~left & ~center & right) ? 1 :
      //        0;
      //
      // Can be implemented by the expression:
      // next = (~left & center) | (center ^ right);
      rule110_cell = (~left & center) | (center ^ right);
    end
  endfunction

  reg [511:0] q_next;

  integer i;
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Compute next state for each cell
      for (i = 0; i < 512; i = i + 1) begin
        bit left, center, right;
        left = (i == 511) ? 1'b0 : q[i+1];
        center = q[i];
        right = (i == 0) ? 1'b0 : q[i-1];
        q_next[i] = rule110_cell(left, center, right);
      end
      q <= q_next;
    end
  end

endmodule