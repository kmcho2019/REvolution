module TopModule (
  input [3:0] in,
  output reg [1:0] pos
);

// Implementing the priority encoder logic
always @* begin
  pos = 2'b00; // Default output position
  
  for (int i = 0; i < 4; i = i + 1) begin
    if (in[i] == 1) begin
      pos = i; // Set position to the first '1' bit encountered
      break;
    end
  end
end

endmodule