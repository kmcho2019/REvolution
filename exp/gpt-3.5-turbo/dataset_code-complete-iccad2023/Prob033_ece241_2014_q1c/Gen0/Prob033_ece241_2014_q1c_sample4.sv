module TopModule (
  input [7:0] a,
  input [7:0] b,
  output [7:0] s,
  output overflow
);
  
  reg [8:0] temp_sum;

  assign s = temp_sum[7:0];
  assign overflow = temp_sum[8] ^ temp_sum[7]; // XOR of MSBs of sum and carry-out

  always @* begin
    temp_sum = a + b;
  end

endmodule