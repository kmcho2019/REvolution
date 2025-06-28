module TopModule (
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

always @* begin
    case ({y, x})
        3'b0000: Y0 = 1'b0;
        3'b0001: Y0 = 1'b1;
        3'b0010: Y0 = 1'b0;
        3'b0011: Y0 = 1'b0;
        3'b0100: Y0 = 1'b1;
        default: Y0 = 1'b0;
    endcase
end

always @* begin
    case(y)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule