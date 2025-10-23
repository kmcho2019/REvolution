module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

    reg [2:0] nextState;

    // Define the lookup table for next states
    reg [2:0] lut [6][2];

    initial begin
        // Initialize the LUT with next states for each current state and input combination
        lut[0][0] = 3'b001; // State A, input 0
        lut[0][1] = 3'b000; // State A, input 1
        lut[1][0] = 3'b010; // State B, input 0
        lut[1][1] = 3'b011; // State B, input 1
        lut[2][0] = 3'b100; // State C, input 0
        lut[2][1] = 3'b011; // State C, input 1
        lut[3][0] = 3'b101; // State D, input 0
        lut[3][1] = 3'b000; // State D, input 1
        lut[4][0] = 3'b100; // State E, input 0
        lut[4][1] = 3'b011; // State E, input 1
        lut[5][0] = 3'b010; // State F, input 0
        lut[5][1] = 3'b011; // State F, input 1
    end

    always @(y, w) begin
        // Determine the next state based on the current state and input
        nextState = lut[y][w];
        Y1 = nextState[1];
    end

endmodule