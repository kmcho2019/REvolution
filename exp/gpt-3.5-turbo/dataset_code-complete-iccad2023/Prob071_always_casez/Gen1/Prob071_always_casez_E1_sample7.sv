module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @* begin
    pos = 3'b0; // Initialize position to 0

    pos = (~in & (in ^ (in-1))).countLeadingZeros();

end

endmodule