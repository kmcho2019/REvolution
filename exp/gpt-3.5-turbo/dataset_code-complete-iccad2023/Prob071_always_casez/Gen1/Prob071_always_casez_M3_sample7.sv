module PriorityEncoder (
  input [7:0] in,
  output reg [2:0] pos
);

reg [2:0] position;

always @* begin
  position = 3'b0;
  for (int i = 0; i < 8; i = i + 1) begin
    if (in[i] == 1'b1) begin
      position = i;
      break;
    end
  end
  pos = position;
end

endmodule