module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    reg [2:0] next_state;

    // Define the lookup table for next states
    reg [2:0] next_states [8][2];

    initial begin
        // Initialize the lookup table
        next_states[0][0] = 3'b001; // A, w = 0
        next_states[0][1] = 3'b000; // A, w = 1
        next_states[1][0] = 3'b010; // B, w = 0
        next_states[1][1] = 3'b011; // B, w = 1
        next_states[2][0] = 3'b100; // C, w = 0
        next_states[2][1] = 3'b011; // C, w = 1
        next_states[3][0] = 3'b101; // D, w = 0
        next_states[3][1] = 3'b000; // D, w = 1
        next_states[4][0] = 3'b100; // E, w = 0
        next_states[4][1] = 3'b011; // E, w = 1
        next_states[5][0] = 3'b010; // F, w = 0
        next_states[5][1] = 3'b011; // F, w = 1
        next_states[6][0] = 3'b000; // G, w = 0 (not used)
        next_states[6][1] = 3'b000; // G, w = 1 (not used)
        next_states[7][0] = 3'b000; // H, w = 0 (not used)
        next_states[7][1] = 3'b000; // H, w = 1 (not used)
    end

    always @(*) begin
        // Calculate the next state using the lookup table
        next_state = next_states[y][w];
    end

    assign Y1 = next_state[1];

endmodule