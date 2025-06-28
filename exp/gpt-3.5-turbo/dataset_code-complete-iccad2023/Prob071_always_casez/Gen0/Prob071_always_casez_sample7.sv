module PriorityEncoder (
  input [7:0] in,
  output reg [2:0] pos
);

integer i;

always @(in) begin
  pos = 3'b0;
  for (i = 0; i < 8; i = i + 1) begin
    if (in[i] == 1'b1) begin
      pos = i;
      break;
    end
  end
end

endmodule