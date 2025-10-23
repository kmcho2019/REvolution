module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

    reg [2:0] next_state;

    // Define the lookup table for next-state values
    reg [2:0] lut [6][2] = {
        {3'b001, 3'b000},  // State A
        {3'b010, 3'b011},  // State B
        {3'b100, 3'b011},  // State C
        {3'b101, 3'b000},  // State D
        {3'b100, 3'b011},  // State E
        {3'b010, 3'b011}   // State F
    };

    always @(y or w) begin
        // Use the current state and input to index into the LUT
        if (w)
            next_state = lut[y][1];
        else
            next_state = lut[y][0];
    end

    assign Y1 = next_state[1]; // Assign the next state to the output

endmodule