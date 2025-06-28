module TopModule (
  input clk,
  input j,
  input k,
  output reg Q
);
  
  always @(posedge clk) begin
    case ({j, k})
      2'b00: Q <= Q;          // Q remains the same
      2'b01: Q <= 1'b0;        // Clear output
      2'b10: Q <= 1'b1;        // Set output
      2'b11: Q <= ~Q;          // Toggle output
      default: Q <= Q;
    endcase
  end

endmodule