module TopModule(
    input  a,
    input  b,
    output q
);

    // Define a lookup table (LUT) to implement the AND gate
    // For a 2-input LUT, we have 4 possible combinations (2^2)
    // The LUT is populated based on the truth table of an AND gate
    reg [1:0] lut [3:0];
    initial begin
        lut[0] = 2'b00; // a=0, b=0, q=0
        lut[1] = 2'b00; // a=0, b=1, q=0
        lut[2] = 2'b00; // a=1, b=0, q=0
        lut[3] = 2'b01; // a=1, b=1, q=1
    end

    // Use the LUT to determine the output q based on inputs a and b
    always @(*) begin
        case ({a, b})
            2'b00: q = lut[0][1];
            2'b01: q = lut[1][1];
            2'b10: q = lut[2][1];
            2'b11: q = lut[3][1];
        endcase
    end

endmodule