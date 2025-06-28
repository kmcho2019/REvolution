module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);

always @* begin
  pos = (~(|in) == 4'b0000) ? 2'b00 : {in[3], in[2]};
end

endmodule