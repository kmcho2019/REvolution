module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Define LUTs for next state and output
    wire [3:0] next_state_lut [0:7];
    wire [0:0] out_lut [0:7];

    // Initialize LUTs based on the state transition and output tables
    initial begin
        // For each state (A, B, C, D) and input (0, 1), define the next state
        next_state_lut[{4'b0001, 1'b0}] = 4'b0001; // A, in=0 -> A
        next_state_lut[{4'b0001, 1'b1}] = 4'b0010; // A, in=1 -> B
        next_state_lut[{4'b0010, 1'b0}] = 4'b0100; // B, in=0 -> C
        next_state_lut[{4'b0010, 1'b1}] = 4'b0010; // B, in=1 -> B
        next_state_lut[{4'b0100, 1'b0}] = 4'b0001; // C, in=0 -> A
        next_state_lut[{4'b0100, 1'b1}] = 4'b1000; // C, in=1 -> D
        next_state_lut[{4'b1000, 1'b0}] = 4'b0100; // D, in=0 -> C
        next_state_lut[{4'b1000, 1'b1}] = 4'b0010; // D, in=1 -> B
        
        // Define output for each state
        out_lut[4'b0001] = 1'b0; // Output for state A
        out_lut[4'b0010] = 1'b0; // Output for state B
        out_lut[4'b0100] = 1'b0; // Output for state C
        out_lut[4'b1000] = 1'b1; // Output for state D
    end

    // Use the LUTs to determine the next state and output
    assign next_state = next_state_lut[{state, in}];
    assign out = out_lut[state];

endmodule