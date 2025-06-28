module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @* begin
  // Default output value
  pos = 3'd0;

  // Use bitwise AND operation to find the first high bit
  pos = (in[0]) ? 3'b0 : (in[1]) ? 3'b1 : (in[2]) ? 3'b2 : (in[3]) ? 3'b3 :
        (in[4]) ? 3'b4 : (in[5]) ? 3'b5 : (in[6]) ? 3'b6 : (in[7]) ? 3'b7 : 3'd0;
end

endmodule