module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // State transition logic using casez for one-hot decoding
    always_comb begin
        casez (state)
            4'b0001: next_state = in ? 4'b0010 : 4'b0001; // State A transitions
            4'b0010: next_state = in ? 4'b0010 : 4'b0100; // State B transitions
            4'b0100: next_state = in ? 4'b1000 : 4'b0001; // State C transitions
            4'b1000: next_state = in ? 4'b0010 : 4'b0100; // State D transitions
            default: next_state = 4'b0001;                // Default to state A
        endcase
    end

    // Output is high only in state D (one-hot MSB)
    assign out = state[3];

endmodule