module PriorityEncoder(
  input [7:0] in,
  output reg [2:0] pos
);

always @* begin
  pos = 3'd0; // Default value if no 1 is found
  for (int i=0; i<8; i=i+1) begin
    if (in[i] == 1'b1) begin
      pos = i; // Assign the position of the first 1 found
      break; // Exit the loop once the first 1 is found
    end
  end
end

endmodule