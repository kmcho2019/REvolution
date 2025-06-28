module TopModule (
  input [4:1] x,
  output logic f
);

always_comb begin
  case (x)
    // Cell values from the Karnaugh map
    // 00  01  11  10
    // 00 | 1 | 0 | 0 | 1 |
    // 01 | 0 | 0 | 0 | 0 |
    // 11 | 1 | 1 | 1 | 0 |
    // 10 | 1 | 1 | 0 | 1 |
    4'b0000: f = 1'b1;
    4'b0001: f = 1'b0;
    4'b0011: f = 1'b0;
    4'b0010: f = 1'b1;
    4'b1100: f = 1'b1;
    4'b1101: f = 1'b1;
    4'b1111: f = 1'b1;
    4'b1110: f = 1'b0;
    4'b1000: f = 1'b1;
    4'b1001: f = 1'b1;
    4'b1011: f = 1'b0;
    4'b1010: f = 1'b1;
    default: f = 1'b0; // Default case for safety
  endcase
end

endmodule