module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);

  always @* begin
    pos = 2'b00; // Initialize output

    pos = ($clog2(in) - 1) & (in & ~($bits(pos)));
  end

endmodule