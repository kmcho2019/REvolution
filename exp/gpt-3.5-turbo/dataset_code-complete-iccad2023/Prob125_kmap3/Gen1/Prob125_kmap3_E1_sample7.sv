module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

// Direct mapping using case statement based on Karnaugh map
always @* begin
  case({c, d, a, b})
    4'b0001: out = 1; // Corresponds to c=0, d=0, a=0, b=1
    4'b0011: out = 1; // Corresponds to c=0, d=1, a=any, b=1
    4'b0111: out = 1; // Corresponds to c=1, d=1, a=any, b=any
    default: out = 0; // Output 0 for all other cases
  endcase
end

endmodule