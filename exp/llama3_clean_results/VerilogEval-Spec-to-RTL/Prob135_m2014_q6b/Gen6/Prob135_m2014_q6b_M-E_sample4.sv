module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

reg [2:0] lut [8];

initial begin
    // Initialize the LUT with the next-state values for y[1]
    lut[0] = 3'b000;  // A (0) --0--> B
    lut[1] = 3'b001;  // A (0) --1--> A
    lut[2] = 3'b000;  // B (0) --0--> C
    lut[3] = 3'b001;  // B (0) --1--> D
    lut[4] = 3'b001;  // C (0) --0--> E
    lut[5] = 3'b001;  // C (0) --1--> D
    lut[6] = 3'b001;  // D (0) --0--> F
    lut[7] = 3'b000;  // D (0) --1--> A
end

always @(*) begin
    // Use the current state (y) and input (w) to index into the LUT
    if (w == 1'b0) begin
        case (y)
            3'b000: Y1 = lut[0][1];
            3'b001: Y1 = lut[2][1];
            3'b010: Y1 = lut[4][1];
            3'b011: Y1 = lut[6][1];
            3'b100: Y1 = lut[7][1];
            3'b101: Y1 = lut[7][1];
            default: Y1 = 1'b0;
        endcase
    end else begin
        case (y)
            3'b000: Y1 = lut[1][1];
            3'b001: Y1 = lut[3][1];
            3'b010: Y1 = lut[5][1];
            3'b011: Y1 = lut[7][1];
            3'b100: Y1 = lut[7][1];
            3'b101: Y1 = lut[7][1];
            default: Y1 = 1'b0;
        endcase
    end
end

endmodule