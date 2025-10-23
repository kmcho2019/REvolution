module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot encoding: 6 bits for 6 states
    // bit0: A, bit1: B, bit2: C, bit3: D, bit4: E, bit5: F
    reg [5:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        next_state = 6'b0;

        casez (state)
            6'b000001: // A
                if (w == 1'b0) next_state[1] = 1'b1; // B
                else           next_state[0] = 1'b1; // A

            6'b000010: // B
                if (w == 1'b0) next_state[2] = 1'b1; // C
                else           next_state[3] = 1'b1; // D

            6'b000100: // C
                if (w == 1'b0) next_state[4] = 1'b1; // E
                else           next_state[3] = 1'b1; // D

            6'b001000: // D
                if (w == 1'b0) next_state[5] = 1'b1; // F
                else           next_state[0] = 1'b1; // A

            6'b010000: // E
                if (w == 1'b0) next_state[4] = 1'b1; // E
                else           next_state[3] = 1'b1; // D

            6'b100000: // F
                if (w == 1'b0) next_state[2] = 1'b1; // C
                else           next_state[3] = 1'b1; // D

            default: 
                next_state[0] = 1'b1; // Default to A if invalid state
        endcase
    end

    // Sequential logic for state update
    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001; // Reset to A
        else
            state <= next_state;
    end

    // Output z = 1 when state is E or F
    assign z = state[4] | state[5];

endmodule