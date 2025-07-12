module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Define the LUT for the next state values
    reg [1:0] lut_Y1_Y3;
    always @(*) begin
        case ({y, w})
            // A (0) --1--> B
            6'b000001_1: lut_Y1_Y3 = 2'b01_0;
            // A (0) --0--> A
            6'b000001_0: lut_Y1_Y3 = 2'b00_0;
            // B (0) --1--> C
            6'b000010_1: lut_Y1_Y3 = 2'b10_0;
            // B (0) --0--> D
            6'b000010_0: lut_Y1_Y3 = 2'b00_1;
            // C (0) --1--> E
            6'b000100_1: lut_Y1_Y3 = 2'b00_0;
            // C (0) --0--> D
            6'b000100_0: lut_Y1_Y3 = 2'b00_1;
            // D (0) --1--> F
            6'b001000_1: lut_Y1_Y3 = 2'b00_0;
            // D (0) --0--> A
            6'b001000_0: lut_Y1_Y3 = 2'b00_0;
            // E (1) --1--> E
            6'b010000_1: lut_Y1_Y3 = 2'b00_0;
            // E (1) --0--> D
            6'b010000_0: lut_Y1_Y3 = 2'b00_1;
            // F (1) --1--> C
            6'b100000_1: lut_Y1_Y3 = 2'b10_0;
            // F (1) --0--> D
            6'b100000_0: lut_Y1_Y3 = 2'b00_1;
            default: lut_Y1_Y3 = 2'b00_0;
        endcase
    end

    // Assign the next state values to the outputs
    assign Y1 = lut_Y1_Y3[1];
    assign Y3 = lut_Y1_Y3[0];

endmodule