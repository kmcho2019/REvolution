module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);

  always @* begin
    case(in)
      4'b0000 : pos = 2'b00; // No bits high, output zero
      default : pos = $clog2(in & -in) - 1; // Find position of highest bit using reduction operator
    endcase
  end

endmodule