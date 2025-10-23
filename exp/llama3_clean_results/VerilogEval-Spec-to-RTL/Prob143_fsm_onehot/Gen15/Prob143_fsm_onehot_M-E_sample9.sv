module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    reg [9:0] state_transitions_lut [2]; // LUT for state transitions
    reg [1:0] output_logic_lut [10]; // LUT for output logic

    integer i;

    // Initialize state transitions LUT
    initial begin
        state_transitions_lut[0] = 10'b0000000001; // Next state for in = 0
        state_transitions_lut[1] = 10'b0000000010; // Next state for in = 1
    end

    // Initialize output logic LUT
    initial begin
        output_logic_lut[0] = 2'b00; // Output for S0
        output_logic_lut[1] = 2'b00; // Output for S1
        output_logic_lut[2] = 2'b00; // Output for S2
        output_logic_lut[3] = 2'b00; // Output for S3
        output_logic_lut[4] = 2'b00; // Output for S4
        output_logic_lut[5] = 2'b00; // Output for S5
        output_logic_lut[6] = 2'b00; // Output for S6
        output_logic_lut[7] = 2'b01; // Output for S7
        output_logic_lut[8] = 2'b10; // Output for S8
        output_logic_lut[9] = 2'b11; // Output for S9
    end

    always @(*) begin
        next_state = 10'b0; // Initialize next_state to zero
        out1 = 1'b0; // Initialize out1 to zero
        out2 = 1'b0; // Initialize out2 to zero

        // Compute next states and outputs based on current state and input
        for (i = 0; i < 10; i++) begin
            if (state[i]) begin
                next_state = next_state | (state_transitions_lut[in] << i);
                out1 = out1 | (output_logic_lut[i][1] & state[i]);
                out2 = out2 | (output_logic_lut[i][0] & state[i]);
            end
        end
    end

endmodule