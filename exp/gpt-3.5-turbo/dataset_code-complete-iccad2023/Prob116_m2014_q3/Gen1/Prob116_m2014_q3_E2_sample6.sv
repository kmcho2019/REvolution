module TopModule (
  input [4:1] x,
  output logic f
);
  
  // Implementing the function f based on the simplified truth table
  always_comb begin
    case({x[3], x[2]})
      2'b00: f = 1;           // d
      2'b01: f = x[1];        // 0 or 1
      2'b11: f = 1;           // d
      2'b10: f = 0;           // d
      default: f = 0;         // Default output
    endcase
  end

endmodule