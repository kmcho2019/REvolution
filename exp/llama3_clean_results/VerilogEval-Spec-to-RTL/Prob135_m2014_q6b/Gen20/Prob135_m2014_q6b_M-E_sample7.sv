module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    reg [2:0] next_state;
    reg [2:0] lut [8];

    initial begin
        // Initialize the LUT with the next states for each current state and input combination
        lut[0] = 3'b001; // A, w = 0
        lut[1] = 3'b000; // A, w = 1
        lut[2] = 3'b010; // B, w = 0
        lut[3] = 3'b011; // B, w = 1
        lut[4] = 3'b100; // C, w = 0
        lut[5] = 3'b011; // C, w = 1
        lut[6] = 3'b101; // D, w = 0
        lut[7] = 3'b000; // D, w = 1
        lut[8] = 3'b100; // E, w = 0
        lut[9] = 3'b011; // E, w = 1
        lut[10] = 3'b010; // F, w = 0
        lut[11] = 3'b011; // F, w = 1
        lut[12] = 3'b100; // E, w = 0
        lut[13] = 3'b011; // E, w = 1
        lut[14] = 3'b010; // F, w = 0
        lut[15] = 3'b011; // F, w = 1
    end

    always @(*) begin
        // Determine the next state based on the current state and input value
        if (w == 0) begin
            case (y)
                3'b000: next_state = lut[0];
                3'b001: next_state = lut[2];
                3'b010: next_state = lut[4];
                3'b011: next_state = lut[6];
                3'b100: next_state = lut[8];
                3'b101: next_state = lut[10];
                default: next_state = lut[0];
            endcase
        end else begin
            case (y)
                3'b000: next_state = lut[1];
                3'b001: next_state = lut[3];
                3'b010: next_state = lut[5];
                3'b011: next_state = lut[7];
                3'b100: next_state = lut[9];
                3'b101: next_state = lut[11];
                default: next_state = lut[1];
            endcase
        end
    end

    assign Y1 = next_state[1];

endmodule