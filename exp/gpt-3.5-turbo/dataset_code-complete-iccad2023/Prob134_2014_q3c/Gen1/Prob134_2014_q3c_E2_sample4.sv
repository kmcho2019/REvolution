module TopModule (
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

// State transition logic for Y[0]
always @*
begin
    case ({y,x})
        6'b00000: Y0 = 1'b0;
        6'b00001: Y0 = 1'b1;
        6'b00010: Y0 = 1'b0;
        6'b00011: Y0 = 1'b0;
        6'b00100: Y0 = 1'b1;
        default: Y0 = 1'b0;
    endcase
end

// Output logic for z
always @*
begin
    case(y)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule