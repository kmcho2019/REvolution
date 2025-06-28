module PriorityEncoder (
  input [7:0] in,
  output reg [2:0] pos
);

always @(*) begin
  pos = 0; // Default position if no high bit is found

  for (int i=0; i<8; i=i+1) begin
    if (in[i] == 1) begin
      pos = i;
      break; // Exit loop once the first high bit is found
    end
  end
end

endmodule