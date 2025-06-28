module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

reg [2:0] next_state;

always @*
begin
  case({y, x})
    6'b00000: begin Y0 = 1'b0; z = 1'b0; next_state = 3'b000; end
    6'b00001: begin Y0 = 1'b1; z = 1'b0; next_state = 3'b001; end
    6'b00010: begin Y0 = 1'b0; z = 1'b0; next_state = 3'b010; end
    6'b00011: begin Y0 = 1'b0; z = 1'b1; next_state = 3'b001; end
    6'b00100: begin Y0 = 1'b1; z = 1'b1; next_state = 3'b100; end
    default: begin Y0 = 1'b0; z = 1'b0; next_state = 3'b000; end
  endcase
end

endmodule