module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Define the lookup table for next states
    reg [3:0] next_state_lut [8]; // 2^3 (state) * 2 (input)
    initial begin
        // State A (4'b0001)
        next_state_lut[0] = 4'b0001; // in = 0
        next_state_lut[1] = 4'b0010; // in = 1
        // State B (4'b0010)
        next_state_lut[2] = 4'b0100; // in = 0
        next_state_lut[3] = 4'b0010; // in = 1
        // State C (4'b0100)
        next_state_lut[4] = 4'b0001; // in = 0
        next_state_lut[5] = 4'b1000; // in = 1
        // State D (4'b1000)
        next_state_lut[6] = 4'b0100; // in = 0
        next_state_lut[7] = 4'b0010; // in = 1
    end

    // Define the lookup table for outputs
    reg [0:0] out_lut [4]; // 2^2 (states)
    initial begin
        out_lut[0] = 1'b0; // State A
        out_lut[1] = 1'b0; // State B
        out_lut[2] = 1'b0; // State C
        out_lut[3] = 1'b1; // State D
    end

    // Calculate the index for the next state LUT
    wire [2:0] next_state_index = {state[3:1], in};

    // Assign next state from the LUT
    assign next_state = next_state_lut[next_state_index];

    // Assign output from the LUT based on the current state
    assign out = out_lut[state[3:0]];

endmodule