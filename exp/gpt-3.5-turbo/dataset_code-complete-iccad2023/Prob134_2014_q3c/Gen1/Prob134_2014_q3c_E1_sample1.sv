module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

always @* begin
    case({y, x})
        // Next state for Y0 based on present state and input
        6'b000000 : Y0 = 1'b0;
        6'b000001 : Y0 = 1'b1;
        6'b000010 : Y0 = 1'b0;
        6'b000011 : Y0 = 1'b0;
        6'b000100 : Y0 = 1'b1;
        default  : Y0 = 1'b0;
    endcase

    // Output z based on the present state input y[2:0]
    case(y)
        3'b011 : z = 1'b1;
        3'b100 : z = 1'b1;
        default  : z = 1'b0;
    endcase
end

endmodule