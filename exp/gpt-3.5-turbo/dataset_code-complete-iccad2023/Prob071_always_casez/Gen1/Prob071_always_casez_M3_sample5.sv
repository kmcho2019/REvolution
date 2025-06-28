module PriorityEncoder (
  input [7:0] in,
  output reg [2:0] pos
);

always @* begin
  pos = 3'b0; // Default value if no '1' is found
  for (int i=0; i<8; i=i+1) begin
    if (in[i] == 1'b1) begin
      pos = i; // Assign the position when '1' is found
      // No need for break, as combinational logic will capture the first '1'
    end
  end
end

endmodule