module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

    reg [1:0] lut_A [2:0] = '{2'b00, 2'b01, 2'b00}; // LUT for state A transitions
    reg [1:0] lut_B [2:0] = '{2'b10, 2'b11, 2'b01}; // LUT for state B transitions
    reg [1:0] lut_C [2:0] = '{2'b10, 2'b11, 2'b01}; // LUT for state C transitions
    reg [1:0] lut_D [2:0] = '{2'b10, 2'b00, 2'b11}; // LUT for state D transitions
    reg [1:0] lut_E [2:0] = '{2'b10, 2'b11, 2'b01}; // LUT for state E transitions
    reg [1:0] lut_F [2:0] = '{2'b01, 2'b11, 2'b01}; // LUT for state F transitions

    reg [1:0] lut [7:0] [2:0]; // Define the LUT

    initial begin
        lut[0] = lut_A;
        lut[1] = lut_B;
        lut[2] = lut_C;
        lut[3] = lut_D;
        lut[4] = lut_E;
        lut[5] = lut_F;
    end

    always @(y, w) begin
        case (y)
            3'b000: Y1 = lut[0][w];
            3'b001: Y1 = lut[1][w];
            3'b010: Y1 = lut[2][w];
            3'b011: Y1 = lut[3][w];
            3'b100: Y1 = lut[4][w];
            3'b101: Y1 = lut[5][w];
            default: Y1 = 1'b0;
        endcase
    end

endmodule