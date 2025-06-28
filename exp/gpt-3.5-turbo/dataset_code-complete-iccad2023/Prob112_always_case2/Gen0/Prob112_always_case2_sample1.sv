module TopModule (
  input [3:0] in,
  output reg [1:0] pos
);

always @* begin
  pos = 2'b0; // default position
  for (int i=0; i<4; i=i+1) begin
    if (in[i] == 1'b1) begin
      pos = i;
      break; // exit loop when a high bit is found
    end
  end
end

endmodule