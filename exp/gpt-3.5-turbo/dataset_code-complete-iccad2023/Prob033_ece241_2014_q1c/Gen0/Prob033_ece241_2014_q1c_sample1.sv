module TopModule (
  input [7:0] a,
  input [7:0] b,
  output [7:0] s,
  output overflow
);

reg [8:0] temp;

always @(*)
begin
  temp = {1'b0, a} + {1'B0, b}; // 2's complement addition
end

assign s = temp[7:0];
assign overflow = temp[8] ^ temp[7]; // Overflow occurs when MSB of sum is different from carry out of MSB
endmodule