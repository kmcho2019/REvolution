module TopModule (
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

always @*
begin
  case({y, x})
    6'b00000: begin Y0 = 1'b0; z = 1'b0; end
    6'b00001: begin Y0 = 1'b0; z = 1'b1; end
    6'b00010: begin Y0 = 1'b1; z = 1'b0; end
    6'b00011: begin Y0 = 1'b0; z = 1'b0; end
    6'b00100: begin Y0 = 1'b1; z = 1'b1; end
    default: begin Y0 = 1'b0; z = 1'b0; end
  endcase
end

endmodule