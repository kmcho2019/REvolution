module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    wire [2:0] next_state [6][2];

    // Initialize the LUT with the next states for each current state and input combination
    initial begin
        next_state[0][0] = 3'b001; // A, w = 0 -> B
        next_state[0][1] = 3'b000; // A, w = 1 -> A
        next_state[1][0] = 3'b010; // B, w = 0 -> C
        next_state[1][1] = 3'b011; // B, w = 1 -> D
        next_state[2][0] = 3'b100; // C, w = 0 -> E
        next_state[2][1] = 3'b011; // C, w = 1 -> D
        next_state[3][0] = 3'b101; // D, w = 0 -> F
        next_state[3][1] = 3'b000; // D, w = 1 -> A
        next_state[4][0] = 3'b100; // E, w = 0 -> E
        next_state[4][1] = 3'b011; // E, w = 1 -> D
        next_state[5][0] = 3'b010; // F, w = 0 -> C
        next_state[5][1] = 3'b011; // F, w = 1 -> D
    end

    // Use the current state and input to index into the LUT and retrieve the next state
    always @(y or w) begin
        if (y == 3'b000) next_state[0][w] = next_state[y][w];
        else if (y == 3'b001) next_state[1][w] = next_state[y][w];
        else if (y == 3'b010) next_state[2][w] = next_state[y][w];
        else if (y == 3'b011) next_state[3][w] = next_state[y][w];
        else if (y == 3'b100) next_state[4][w] = next_state[y][w];
        else if (y == 3'b101) next_state[5][w] = next_state[y][w];
    end

    // Assign the next state to the output
    assign Y1 = next_state[y][w][1];

endmodule