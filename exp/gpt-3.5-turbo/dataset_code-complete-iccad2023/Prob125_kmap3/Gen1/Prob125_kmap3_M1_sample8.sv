module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

always @*
begin
  case({c, d})
    2'b00: out <= 1; // Corresponds to cell (0,0) in the Karnaugh map
    2'b01: out <= 0; // Corresponds to cell (0,1) in the Karnaugh map
    2'b10: out <= (a & b); // Corresponds to cell (1,0) in the Karnaugh map
    2'b11: out <= 1; // Corresponds to cells (1,1), (1,2), and (1,3) in the Karnaugh map
    default: out <= 0; // For any other input combinations
  endcase
end

endmodule