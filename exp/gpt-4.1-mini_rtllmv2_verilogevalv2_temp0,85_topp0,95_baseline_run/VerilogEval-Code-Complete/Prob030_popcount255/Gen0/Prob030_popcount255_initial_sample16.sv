module TopModule (
  input [254:0] in,
  output reg [7:0] out
);

  integer i;
  reg [7:0] chunk_count [0:31]; // 31 chunks of 8 bits + 1 chunk of 7 bits
  reg [7:0] total_count;

  // Function to count bits in an 8-bit vector
  function [3:0] popcount8;
    input [7:0] x;
    integer j;
    begin
      popcount8 = 0;
      for (j = 0; j < 8; j = j + 1)
        popcount8 = popcount8 + x[j];
    end
  endfunction

  // Function to count bits in a 7-bit vector
  function [3:0] popcount7;
    input [6:0] x;
    integer j;
    begin
      popcount7 = 0;
      for (j = 0; j < 7; j = j + 1)
        popcount7 = popcount7 + x[j];
    end
  endfunction

  always @(*) begin
    // Count in first 31 chunks of 8 bits
    for (i = 0; i < 31; i = i + 1) begin
      chunk_count[i] = popcount8(in[i*8 +: 8]);
    end
    // Count in last chunk of 7 bits
    chunk_count[31] = popcount7(in[248 +: 7]);

    // Sum all partial counts
    total_count = 0;
    for (i = 0; i < 32; i = i + 1)
      total_count = total_count + chunk_count[i];

    out = total_count;
  end

endmodule