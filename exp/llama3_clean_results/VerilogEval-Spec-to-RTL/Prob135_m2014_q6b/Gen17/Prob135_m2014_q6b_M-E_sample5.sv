module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    reg [2:0] next_state;
    reg [2:0] state_lut [6][2];

    initial begin
        state_lut[0][0] = 3'b001; // A, w = 0
        state_lut[0][1] = 3'b000; // A, w = 1
        state_lut[1][0] = 3'b010; // B, w = 0
        state_lut[1][1] = 3'b011; // B, w = 1
        state_lut[2][0] = 3'b100; // C, w = 0
        state_lut[2][1] = 3'b011; // C, w = 1
        state_lut[3][0] = 3'b101; // D, w = 0
        state_lut[3][1] = 3'b000; // D, w = 1
        state_lut[4][0] = 3'b100; // E, w = 0
        state_lut[4][1] = 3'b011; // E, w = 1
        state_lut[5][0] = 3'b010; // F, w = 0
        state_lut[5][1] = 3'b011; // F, w = 1
    end

    always @(*) begin
        case (y)
            3'b000: next_state = state_lut[0][w];
            3'b001: next_state = state_lut[1][w];
            3'b010: next_state = state_lut[2][w];
            3'b011: next_state = state_lut[3][w];
            3'b100: next_state = state_lut[4][w];
            3'b101: next_state = state_lut[5][w];
            default: next_state = 3'b000;
        endcase
    end

    assign Y1 = next_state[1];

endmodule