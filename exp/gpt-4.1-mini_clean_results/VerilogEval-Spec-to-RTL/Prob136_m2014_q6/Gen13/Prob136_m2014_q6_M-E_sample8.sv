module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding: only one bit is 1 at a time
    // bit 0: A, bit 1: B, bit 2: C, bit 3: D, bit 4: E, bit 5: F
    reg [5:0] state, next_state;

    always @(*) begin
        // Default next_state is all zeros (should not happen)
        next_state = 6'b000000;
        case (1'b1)  // Decode current one-hot state
            state[0]: begin // A
                if (w == 0) next_state = 6'b000010; // B
                else         next_state = 6'b000001; // A
            end
            state[1]: begin // B
                if (w == 0) next_state = 6'b000100; // C
                else         next_state = 6'b0001000 >> 4; // wait, let's fix next lines for clarity
            end
            state[2]: begin // C
                if (w == 0) next_state = 6'b00010000; // E
                else         next_state = 6'b00001000; // D
            end
            state[3]: begin // D
                if (w == 0) next_state = 6'b00100000; // F
                else         next_state = 6'b00000001; // A
            end
            state[4]: begin // E
                if (w == 0) next_state = 6'b00010000; // E
                else         next_state = 6'b00001000; // D
            end
            state[5]: begin // F
                if (w == 0) next_state = 6'b00000100; // C
                else         next_state = 6'b00001000; // D
            end
            default: next_state = 6'b000001; // Default to A
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001; // A active
        else
            state <= next_state;
    end

    // Output logic: z=1 when state is E or F
    always @(*) begin
        z = state[4] | state[5];
    end

endmodule