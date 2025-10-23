module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot encoding for states: A-F as bits [0:5]
    // State bits: A=bit0, B=bit1, C=bit2, D=bit3, E=bit4, F=bit5
    reg [5:0] state, next_state;

    // Combinational next_state logic using one-hot encoding
    always @(*) begin
        // Default to no state active to avoid latches
        next_state = 6'b0;
        case (1'b1)
            state[0]: // A
                if (w == 1'b0)
                    next_state[1] = 1'b1; // B
                else
                    next_state[0] = 1'b1; // A
            state[1]: // B
                if (w == 1'b0)
                    next_state[2] = 1'b1; // C
                else
                    next_state[3] = 1'b1; // D
            state[2]: // C
                if (w == 1'b0)
                    next_state[4] = 1'b1; // E
                else
                    next_state[3] = 1'b1; // D
            state[3]: // D
                if (w == 1'b0)
                    next_state[5] = 1'b1; // F
                else
                    next_state[0] = 1'b1; // A
            state[4]: // E
                if (w == 1'b0)
                    next_state[4] = 1'b1; // E
                else
                    next_state[3] = 1'b1; // D
            state[5]: // F
                if (w == 1'b0)
                    next_state[2] = 1'b1; // C
                else
                    next_state[3] = 1'b1; // D
            default:
                next_state[0] = 1'b1; // Default to A if no state active
        endcase
    end

    // Sequential logic: update state on clk posedge or reset
    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001; // Start in state A
        else
            state <= next_state;
    end

    // Output logic: z = 1 if in state E or F
    assign z = state[4] | state[5];

endmodule