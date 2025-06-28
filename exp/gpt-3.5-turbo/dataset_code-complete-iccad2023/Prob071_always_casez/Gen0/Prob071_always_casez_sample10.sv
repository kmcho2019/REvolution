module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

integer i;

always @* begin
  pos = 3'd0;
  for (i = 0; i < 8; i = i + 1) begin
    if (in[i] == 1) begin
      pos = i + 1;
      break;
    end
  end
end

endmodule