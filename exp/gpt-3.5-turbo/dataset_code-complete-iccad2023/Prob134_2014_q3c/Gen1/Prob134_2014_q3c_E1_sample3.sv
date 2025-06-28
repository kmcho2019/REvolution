module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

always @* begin
  case ({y, x})
    7'b000_0:
      begin
        Y0 = 3'b000;
        z = 1'b0;
      end

    7'b001_0:
      begin
        Y0 = 3'b001;
        z = 1'b0;
      end

    7'b010_0:
      begin
        Y0 = 3'b010;
        z = 1'b0;
      end

    7'b011_0:
      begin
        Y0 = 3'b001;
        z = 1'b1;
      end

    7'b100_0:
      begin
        Y0 = 3'b011;
        z = 1'b1;
      end

    default:
      begin
        Y0 = 3'b000;  // Default case for any undefined states
        z = 1'b0;     // Default output when state, input combination is not specified
      end
  endcase
end

endmodule