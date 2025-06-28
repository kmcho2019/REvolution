module TopModule (
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

always @(*) begin
  case(y)
    3'b000:
      begin
        Y0 = x;
        z = 0;
      end
    3'b001:
      begin
        Y0 = (x) ? 4'b100 : 4'b001;
        z = 0;
      end
    3'b010:
      begin
        Y0 = (x) ? 4'b001 : 4'b000;
        z = 0;
      end
    3'b011:
      begin
        Y0 = (x) ? 4'b010 : 4'b001;
        z = 1;
      end
    3'b100:
      begin
        Y0 = (x) ? 4'b100 : 4'b011;
        z = 1;
      end
  endcase
end

endmodule