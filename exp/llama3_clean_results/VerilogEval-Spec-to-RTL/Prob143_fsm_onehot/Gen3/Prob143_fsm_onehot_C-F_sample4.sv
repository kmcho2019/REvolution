module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    // Define the lookup tables for next states and outputs
    reg [9:0] next_states [10];
    reg [1:0] outputs [10];

    // Initialize the LUTs based on the state machine's logic
    initial begin
        // Next states for in = 0
        next_states[0] = 10'b1; // S0 -> S0
        next_states[1] = 10'b1; // S1 -> S0
        next_states[2] = 10'b1; // S2 -> S0
        next_states[3] = 10'b1; // S3 -> S0
        next_states[4] = 10'b1; // S4 -> S0
        next_states[5] = 10'b100000000; // S5 -> S8
        next_states[6] = 10'b1000000000; // S6 -> S9
        next_states[7] = 10'b1; // S7 -> S0
        next_states[8] = 10'b1; // S8 -> S0
        next_states[9] = 10'b1; // S9 -> S0

        // Next states for in = 1
        next_states[0] = 10'b10; // S0 -> S1
        next_states[1] = 10'b100; // S1 -> S2
        next_states[2] = 10'b1000; // S2 -> S3
        next_states[3] = 10'b10000; // S3 -> S4
        next_states[4] = 10'b100000; // S4 -> S5
        next_states[5] = 10'b1000000; // S5 -> S6
        next_states[6] = 10'b10000000; // S6 -> S7
        next_states[7] = 10'b10000000; // S7 -> S7
        next_states[8] = 10'b10; // S8 -> S1
        next_states[9] = 10'b10; // S9 -> S1

        // Outputs
        outputs[0] = 2'b00; // S0
        outputs[1] = 2'b00; // S1
        outputs[2] = 2'b00; // S2
        outputs[3] = 2'b00; // S3
        outputs[4] = 2'b00; // S4
        outputs[5] = 2'b00; // S5
        outputs[6] = 2'b00; // S6
        outputs[7] = 2'b01; // S7
        outputs[8] = 2'b10; // S8
        outputs[9] = 2'b11; // S9
    end

    always @(*) begin
        next_state = 10'b0;
        out1 = 1'b0;
        out2 = 1'b0;

        // Find the current state
        for (int i = 0; i < 10; i++) begin
            if (state[i] == 1'b1) begin
                // Determine the next state based on the input
                if (in == 1'b0) begin
                    next_state = next_states[i];
                end else begin
                    // For in = 1, we use the predefined next states
                    case (i)
                        0: next_state = 10'b10; // S0 -> S1
                        1: next_state = 10'b100; // S1 -> S2
                        2: next_state = 10'b1000; // S2 -> S3
                        3: next_state = 10'b10000; // S3 -> S4
                        4: next_state = 10'b100000; // S4 -> S5
                        5: next_state = 10'b1000000; // S5 -> S6
                        6: next_state = 10'b10000000; // S6 -> S7
                        7: next_state = 10'b10000000; // S7 -> S7
                        8: next_state = 10'b10; // S8 -> S1
                        9: next_state = 10'b10; // S9 -> S1
                    endcase
                end

                // Determine the outputs
                out1 = outputs[i][1];
                out2 = outputs[i][0];
            end
        end
    end

endmodule