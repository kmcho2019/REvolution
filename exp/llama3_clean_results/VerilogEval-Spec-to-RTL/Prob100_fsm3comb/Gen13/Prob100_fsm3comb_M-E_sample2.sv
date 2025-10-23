module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    reg [1:0] next_state_reg;
    reg out_reg;

    // Lookup table for state transitions and output logic
    reg [1:0] state_transitions [4][2] = {
        {2'b00, 2'b01},  // State A
        {2'b10, 2'b01},  // State B
        {2'b00, 2'b11},  // State C
        {2'b10, 2'b01}   // State D
    };

    reg [0:0] outputs [4] = {
        1'b0,  // State A
        1'b0,  // State B
        1'b0,  // State C
        1'b1   // State D
    };

    always @(*) begin
        // Determine next state based on current state and input
        next_state_reg = state_transitions[state][in];

        // Determine output based on current state
        out_reg = outputs[state];
    end

    assign next_state = next_state_reg;
    assign out = out_reg;

endmodule