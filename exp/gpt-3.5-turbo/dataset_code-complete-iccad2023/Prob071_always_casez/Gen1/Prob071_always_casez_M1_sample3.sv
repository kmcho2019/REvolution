module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @(*) begin
  pos = 0;
  for (int i = 0; i < 8; i = i + 1) begin
    if ((in[i] == 1) && (pos == 0)) begin
      pos = i;
    end
  end
end

endmodule