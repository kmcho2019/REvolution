module TopModule (
  input [3:0] in,
  output reg [1:0] pos
);

always @* begin
  pos = 2'b00; // default output position
  
  for (int i = 0; i < 4; i = i + 1) begin
    if (in[i] == 1) begin
      pos = i; // set position to the first '1' bit encountered
      break;
    end
  end
end

endmodule