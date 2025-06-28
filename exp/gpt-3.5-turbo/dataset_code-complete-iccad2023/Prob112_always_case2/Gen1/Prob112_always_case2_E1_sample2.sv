module UniquePriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);
  
  always @* begin
    pos = 2'b00; // Initialize output
    
    case(in)
      4'b0001: pos = 2'b00; // Bit[0]
      4'b0010: pos = 2'b01; // Bit[1]
      4'b0100: pos = 2'b10; // Bit[2]
      4'b1000: pos = 2'b11; // Bit[3]
      default: pos = 2'b00; // Default if no high bits found
    endcase
  end

endmodule