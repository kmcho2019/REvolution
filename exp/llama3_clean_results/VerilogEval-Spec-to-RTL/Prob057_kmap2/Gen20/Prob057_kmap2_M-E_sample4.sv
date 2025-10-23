module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

// Define the LUTs for each quadrant of the Karnaugh map
reg lut00, lut01, lut10, lut11;

always @(a, b, c, d) begin
    // LUT for quadrant 00 (a = 0, b = 0)
    case ({c, d})
        2'b00: lut00 = 1'b1;
        2'b01: lut00 = 1'b1;
        2'b10: lut00 = 1'b1;
        2'b11: lut00 = 1'b0;
        default: lut00 = 1'b0;
    endcase

    // LUT for quadrant 01 (a = 0, b = 1)
    case ({c, d})
        2'b00: lut01 = 1'b1;
        2'b01: lut01 = 1'b0;
        2'b10: lut01 = 1'b1;
        2'b11: lut01 = 1'b0;
        default: lut01 = 1'b0;
    endcase

    // LUT for quadrant 10 (a = 1, b = 0)
    case ({c, d})
        2'b00: lut10 = 1'b1;
        2'b01: lut10 = 1'b1;
        2'b10: lut10 = 1'b0;
        2'b11: lut10 = 1'b0;
        default: lut10 = 1'b0;
    endcase

    // LUT for quadrant 11 (a = 1, b = 1)
    case ({c, d})
        2'b00: lut11 = 1'b0;
        2'b01: lut11 = 1'b1;
        2'b10: lut11 = 1'b0;
        2'b11: lut11 = 1'b1;
        default: lut11 = 1'b0;
    endcase

    // Combine the outputs of the LUTs using logic gates
    out = (~a & ~b & lut00) | 
          (~a & b & lut01) | 
          (a & ~b & lut10) | 
          (a & b & lut11);
end

endmodule