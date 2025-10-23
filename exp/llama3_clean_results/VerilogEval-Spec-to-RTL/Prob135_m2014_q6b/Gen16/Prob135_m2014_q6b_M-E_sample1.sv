module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    reg [2:0] next_state;
    reg [2:0] lut [8][2];

    initial begin
        // Initialize the LUT with the next states for each current state and input combination
        lut[0][0] = 3'b001; // A, w=0 -> B
        lut[0][1] = 3'b000; // A, w=1 -> A
        lut[1][0] = 3'b010; // B, w=0 -> C
        lut[1][1] = 3'b011; // B, w=1 -> D
        lut[2][0] = 3'b100; // C, w=0 -> E
        lut[2][1] = 3'b011; // C, w=1 -> D
        lut[3][0] = 3'b101; // D, w=0 -> F
        lut[3][1] = 3'b000; // D, w=1 -> A
        lut[4][0] = 3'b100; // E, w=0 -> E
        lut[4][1] = 3'b011; // E, w=1 -> D
        lut[5][0] = 3'b010; // F, w=0 -> C
        lut[5][1] = 3'b011; // F, w=1 -> D
        lut[6][0] = 3'b000; // G, w=0 -> A
        lut[6][1] = 3'b000; // G, w=1 -> A
        lut[7][0] = 3'b000; // H, w=0 -> A
        lut[7][1] = 3'b000; // H, w=1 -> A
    end

    always @(y or w)
    begin
        // Use the current state and input as indices to the LUT to determine the next state
        next_state = lut[y][w];
    end

    assign Y1 = next_state[1];

endmodule