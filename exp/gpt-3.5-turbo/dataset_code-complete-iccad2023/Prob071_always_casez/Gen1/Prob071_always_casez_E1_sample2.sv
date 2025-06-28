module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

reg [7:0] twos_complement;
reg [7:0] and_result;

// Calculate 2's complement of the input
always @(*)
begin
  twos_complement = ~in + 1;
end

// Perform bitwise AND operation
assign and_result = twos_complement & in;

// Priority encoder logic
always @(*)
begin
  pos = 3'b0; // Initialize output to 0

  // Find position of first high bit
  for (int i = 0; i < 8; i=i+1) begin
    if (and_result[i] == 1) begin
      pos = i;
      // Break loop when high bit is found
      i = 8; // Equivalent to 'break' in this context
    end
  end
end

endmodule