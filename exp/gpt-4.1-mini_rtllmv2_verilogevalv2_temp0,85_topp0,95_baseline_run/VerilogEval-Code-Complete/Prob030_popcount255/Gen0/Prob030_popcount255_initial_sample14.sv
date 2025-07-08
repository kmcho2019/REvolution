module TopModule (
  input [254:0] in,
  output reg [7:0] out
);

  // Function to count bits in a 5-bit input
  function [3:0] popcount5;
    input [4:0] bits;
    integer i;
    begin
      popcount5 = 0;
      for (i = 0; i < 5; i = i + 1)
        popcount5 = popcount5 + bits[i];
    end
  endfunction

  integer i;
  reg [7:0] sum;

  always @* begin
    sum = 0;
    // Process 51 chunks of 5 bits (51*5=255 bits)
    for (i = 0; i < 51; i = i + 1) begin
      sum = sum + popcount5(in[i*5 +: 5]);
    end
    out = sum;
  end

endmodule