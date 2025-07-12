module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

    reg [2:0] next_state;
    reg [2:0] lut_state [8]; // 2^3 (8) possible states

    // Initialize the LUT
    initial begin
        lut_state[0] = 3'b001; // A (0) -> B
        lut_state[1] = 3'b000; // A (1) -> A
        lut_state[2] = 3'b010; // B (0) -> C
        lut_state[3] = 3'b011; // B (1) -> D
        lut_state[4] = 3'b100; // C (0) -> E
        lut_state[5] = 3'b011; // C (1) -> D
        lut_state[6] = 3'b101; // D (0) -> F
        lut_state[7] = 3'b000; // D (1) -> A
        lut_state[8] = 3'b100; // E (0) -> E
        lut_state[9] = 3'b011; // E (1) -> D
        lut_state[10] = 3'b010; // F (0) -> C
        lut_state[11] = 3'b011; // F (1) -> D
    end

    always @(y or w) begin
        case (y)
            3'b000: next_state = (w)? lut_state[1] : lut_state[0];
            3'b001: next_state = (w)? lut_state[3] : lut_state[2];
            3'b010: next_state = (w)? lut_state[5] : lut_state[4];
            3'b011: next_state = (w)? lut_state[7] : lut_state[6];
            3'b100: next_state = (w)? lut_state[9] : lut_state[8];
            3'b101: next_state = (w)? lut_state[11] : lut_state[10];
            default: next_state = 3'b000;
        endcase

        Y1 = next_state[1]; // Assign the next state to the output
    end

endmodule