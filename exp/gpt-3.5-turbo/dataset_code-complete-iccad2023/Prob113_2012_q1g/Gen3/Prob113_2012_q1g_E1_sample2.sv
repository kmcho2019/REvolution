module TopModule (
  input [3:0] x,
  output logic f
);

  // Use bitwise logical operations to implement the function f
  always_comb begin
    case (x)
      4'b0000: f = 1'b1;
      4'b0001: f = 1'b0;
      4'b0011: f = 1'b0;
      4'b0010: f = 1'b1;
      4'b1100: f = 1'b1;
      4'b1101: f = 1'b1;
      4'b1111: f = 1'b1;
      4'b1110: f = 1'b0;
      default: begin
                 f = (x & 4'b1010) ^ (x & 4'b0101); // Using bitwise AND and XOR based on Karnaugh map values
               end
    endcase
  end

endmodule