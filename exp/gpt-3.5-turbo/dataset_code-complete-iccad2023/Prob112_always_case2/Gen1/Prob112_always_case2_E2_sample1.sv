module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);

  always @* begin
    pos = 2'b00; // Initialize output
    
    // Perform a bitwise OR operation between the input and its right-shifted version
    // The position of the first high bit will be determined by the leading zero in the result
    pos = (in | (in >> 1))[3:2]; 
  end

endmodule