module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);

always @* begin
  pos = 2'b00; // Initialize output
  case(in) // Use a case statement for efficient position determination
    4'b0001: pos = 2'b00; // Position 0
    4'b0010: pos = 2'b01; // Position 1
    4'b0100: pos = 2'b10; // Position 2
    4'b1000: pos = 2'b11; // Position 3
    default: pos = 2'b00; // Default to 0 when no high bit found
  endcase
end

endmodule