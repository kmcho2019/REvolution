module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

  always @(*) begin
    // Decode y and x for clarity
    // y[2:0] present state
    // x input

    // Output logic for z:
    // From the table, z=1 only for states 011 and 100, else 0
    // So z = (y == 3'b011) or (y == 3'b100)

    z = ((y == 3'b011) || (y == 3'b100)) ? 1'b1 : 1'b0;

    // Next state LSB (Y0) logic:
    // Table from thought:
    // y    x=0 Y0  x=1 Y0
    // 000  0       1
    // 001  1       0
    // 010  0       1
    // 011  1       0
    // 100  1       0

    // Implement as a case or with logic expression.
    // Let's implement as case for clarity:

    case (y)
      3'b000: Y0 = (x == 0) ? 1'b0 : 1'b1;
      3'b001: Y0 = (x == 0) ? 1'b1 : 1'b0;
      3'b010: Y0 = (x == 0) ? 1'b0 : 1'b1;
      3'b011: Y0 = (x == 0) ? 1'b1 : 1'b0;
      3'b100: Y0 = (x == 0) ? 1'b1 : 1'b0;
      default: Y0 = 1'b0; // default safe value
    endcase
  end

endmodule